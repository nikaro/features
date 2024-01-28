#!/bin/sh
# Adapted from https://github.com/devcontainers/features/blob/main/src/docker-in-docker/install.sh

set -e

dockerd_start="$(
  cat <<'INNEREOF'
    # explicitly remove dockerd and containerd PID file to ensure that it can start properly if it was stopped uncleanly
    # ie: docker kill <ID>
    find /run /var/run -iname 'docker*.pid' -delete || :
    find /run /var/run -iname 'container*.pid' -delete || :

    # -- Start: dind wrapper script --
    # Maintained: https://github.com/moby/moby/blob/master/hack/dind

    export container=docker

    if [ -d /sys/kernel/security ] && ! mountpoint -q /sys/kernel/security; then
        mount -t securityfs none /sys/kernel/security || {
            echo >&2 'Could not mount /sys/kernel/security.'
            echo >&2 'AppArmor detection and --privileged mode might break.'
        }
    fi

    # Mount /tmp (conditionally)
    if ! mountpoint -q /tmp; then
        mount -t tmpfs none /tmp
    fi

    set_cgroup_nesting()
    {
        # cgroup v2: enable nesting
        if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
            # move the processes from the root group to the /init group,
            # otherwise writing subtree_control fails with EBUSY.
            # An error during moving non-existent process (i.e., "cat") is ignored.
            mkdir -p /sys/fs/cgroup/init
            xargs -rn1 < /sys/fs/cgroup/cgroup.procs > /sys/fs/cgroup/init/cgroup.procs || :
            # enable controllers
            sed -e 's/ / +/g' -e 's/^/+/' < /sys/fs/cgroup/cgroup.controllers \
                > /sys/fs/cgroup/cgroup.subtree_control
        fi
    }

    # Set cgroup nesting, retrying if necessary
    retry_cgroup_nesting=0

    until [ "${retry_cgroup_nesting}" -eq "5" ];
    do
        set +e
            set_cgroup_nesting

            if [ $? -ne 0 ]; then
                echo "(*) cgroup v2: Failed to enable nesting, retrying..."
            else
                break
            fi

            retry_cgroup_nesting=`expr $retry_cgroup_nesting + 1`
        set -e
    done

    # -- End: dind wrapper script --

    # Start docker/moby engine
    ( dockerd > /tmp/dockerd.log 2>&1 ) &
INNEREOF
)"

sudo_if() {
  COMMAND="$*"

  if [ "$(id -u)" -ne 0 ]; then
    # shellcheck disable=SC2086
    sudo $COMMAND
  else
    $COMMAND
  fi
}

retry_docker_start_count=0
docker_ok="false"

until [ "${docker_ok}" = "true" ] || [ "${retry_docker_start_count}" -eq "5" ]; do
  # Start using sudo if not invoked as root
  if [ "$(id -u)" -ne 0 ]; then
    sudo /bin/sh -c "${dockerd_start}"
  else
    eval "${dockerd_start}"
  fi

  retry_count=0
  until [ "${docker_ok}" = "true" ] || [ "${retry_count}" -eq "5" ]; do
    sleep 1s
    set +e
    docker info >/dev/null 2>&1 && docker_ok="true"
    set -e

    retry_count=$((retry_count + 1))
  done

  if [ "${docker_ok}" != "true" ] && [ "${retry_docker_start_count}" != "4" ]; then
    echo "(*) Failed to start docker, retrying..."
    set +e
    sudo_if pkill dockerd
    sudo_if pkill containerd
    set -e
  fi

  retry_docker_start_count=$((retry_docker_start_count + 1))
done

# Execute whatever commands were passed in (if any). This allows us
# to set this script to ENTRYPOINT while still executing the default CMD.
exec "$@"
