#!/usr/bin/env sh

set -eux;

OUTPUT_FILE="/tmp/install-tl-unx/texlive.profile"
DEFAULT_OPT="${1:-linux/arm64}"

if [ ! -d "/tmp/install-tl-unx/" ]; then
	mkdir -p "/tmp/install-tl-unx";
fi

if [ "${DEFAULT_OPT}" = "linux/amd64" ]; then
	printf "%s\n" \
		"selected_scheme scheme-basic" \
		"binary_aarch64-linux 0" \
		"binary_x86_64-darwin 0" \
		"binary_x86_64-linux 1" \
		"binary_win32 0" \
		"option_doc 0" \
		"option_src 0" \
		"option_autobackup 0" \
		"option_desktop_integration 0" \
		"option_file_assocs 0" \
		> "${OUTPUT_FILE}";

	exit 0;
fi

printf "%s\n" \
	"selected_scheme scheme-basic" \
	"binary_aarch64-linux 1" \
	"binary_x86_64-darwin 0" \
	"binary_x86_64-linux 0" \
	"binary_win32 0" \
	"option_doc 0" \
	"option_src 0" \
	"option_autobackup 0" \
	"option_desktop_integration 0" \
	"option_file_assocs 0" \
	> "${OUTPUT_FILE}";
