all:

lib_script_update:
	@for dir in ./src/*/; do \
		cp -uv ./library_scripts.sh $$dir; \
	done
