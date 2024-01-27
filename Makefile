all:

lib_script_update:
	@for dir in src/*/; do \
		cp -uv src/library_scripts.sh $$dir; \
	done
