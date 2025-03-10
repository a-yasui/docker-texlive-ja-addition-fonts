#!/usr/bin/env sh

set -eux;

DEFAULT_OPT="${1:-'linux/arm64'}"
OUTPUT_FILE="${2:-'/tmp/install-tl-unx/texlive.profile'}"

# See: https://www.tug.org/texlive/doc/install-tl.html#ENVIRONMENT-VARIABLES,
# https://tex.stackexchange.com/a/470341/120853.
# IMPORTANT: Put these into the actual designated container's user's home for full
# write access. Otherwise, we run into all sorts of annoying errors, like
# https://tex.stackexchange.com/q/571021/120853.
# The user we run this as is specified in the Dockerfile and inserted into here.
BINARYOPT=$(printf "%s\n" "binary_aarch64-linux 1" "binary_x86_64-darwin 0" "binary_x86_64-linux 0" "binary_win32 0")
if [ "${DEFAULT_OPT}" = "linux/amd64" ]; then
	BINARYOPT=$(printf "%s\n" "binary_aarch64-linux 0" "binary_x86_64-darwin 0" "binary_x86_64-linux 1" "binary_win32 0")
fi

cat <<__EOL__ > "${OUTPUT_FILE}";
#
# Via: https://github.com/alexpovel/latex-extras-docker/blob/master/config/texlive.profile
#
selected_scheme scheme-basic

TEXMFHOME /home/\${USER}/texmf
TEXMFVAR /home/\${USER}/.texlive/texmf-var
TEXMFCONFIG /home/\${USER}/.texlive/texmf-config
${BINARYOPT}
option_doc 0
option_src 0
option_autobackup 0
option_desktop_integration 0
option_file_assocs 0

# Not required, left at default:
# TEXDIR /usr/local/texlive/<version>
# TEXMFSYSCONFIG /usr/local/texlive/<version>/texmf-config
# TEXMFSYSVAR /usr/local/texlive/<version>/texmf-var
# TEXMFLOCAL /usr/local/texlive/texmf-local
#
# -------------------------------------------------------------------------------
# Collections of packages; for their contents, see
# http://mirror.ctan.org/systems/texlive/tlnet/tlpkg/texlive.tlpdb
# and search for 'name collection-<name>', e.g. 'name collection-basic'.
# At the time of writing, the following encompasses all available collections.
# Only the core ones with very few supported languages are enabled. For example,
# just including 'collection-langjapanese' requires 800MB of space.
# -------------------------------------------------------------------------------
#     collection-basic collection-latex \
#    collection-latexrecommended collection-latexextra \
#    collection-fontsrecommended collection-langjapanese \
#    collection-luatex latexmk \
collection-basic 1
collection-bibtexextra 0
collection-binextra 0
collection-fontsextra 0
collection-fontsrecommended 1
collection-fontutils 0
collection-formatsextra 0
collection-langenglish 1
collection-langeuropean 0
collection-langgerman 0
collection-latex 1
collection-latexextra 1
collection-latexrecommended 1
collection-luatex 1
collection-mathscience 0
collection-pictures 0
collection-plaingeneric 0
collection-publishers 0
collection-xetex 0
#latexmk 1

# -------------------------------------------------------------------------------
# Enable the following disabled ones as needed. They are included here so
# everyone can see what is available; as many as possible are disabled, since
# image size matters. The default is aimed at documents in the sciences domain.
# Therefore, everything else is disabled. This includes various languages, so
# activate your missing language here!
# -------------------------------------------------------------------------------
collection-context 0
collection-games 0
collection-humanities 0
collection-langarabic 0
collection-langchinese 0
collection-langcjk 0
collection-langcyrillic 0
collection-langczechslovak 0
collection-langfrench 0
collection-langgreek 0
collection-langitalian 0
collection-langjapanese 1
collection-langkorean 0
collection-langother 0
collection-langpolish 0
collection-langportuguese 0
collection-langspanish 0
collection-metapost 0
collection-music 0
collection-pstricks 0
collection-texworks 0
collection-wintools 0

# At the same time, TeXLive 2020 does not seem to respect the set TEXDIR, breaking
# installation. However, adjusting the path here automatically works.
# Since older installations will simply ignore this setting, enable it for safety.
instopt_adjustpath 1

# Not Portable
instopt_portable 0

# Create font format files, otherwise they have to be created on the fly each
# time.
tlpdbopt_create_formats 1
# None of the following is required; especially not documentation and source
# files, which fill multiple GBs
tlpdbopt_desktop_integration 0
tlpdbopt_file_assocs 0
tlpdbopt_generate_updmap 0
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
#
# Execute postinstallation code for packages:
tlpdbopt_post_code 1
__EOL__
