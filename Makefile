all:

lib_script_update:
	@for dir in ./src/*/; do \
		cp -v ./library_scripts.sh $$dir; \
	done
