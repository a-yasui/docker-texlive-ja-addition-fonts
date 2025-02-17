#!/usr/bin/env bash
#
# Customze from https://github.com/alexpovel/latex-extras-docker/blob/master/texlive.sh

set -ueo pipefail;

# do this file.
# 1. run `install-tl`
# 2. symlink all tex bin file to /usr/local/bin

WORKDIR=${1:-'/install'}
TEX_PROFILE="${2:-'/install/tex'}"
TEX_REPOSITORY="${3:-'https://mirror.ctan.org/systems/texlive/tlnet/'}"

SYMLINK_DESTINATION="/usr/local/bin"

# From: https://stackoverflow.com/a/2990533/11477374
echoerr() { echo "$@" 1>&2; }

check_path() {
    # The following test assumes the most basic program, `tex`, is present, see also
    # https://www.tug.org/texlive/doc/texlive-en/texlive-en.html#x1-380003.5
    echo "Checking PATH and installation..."
    if tex --version
    then
        echo "PATH and installation seem OK, exiting with success."
        exit 0
    else
        echoerr "PATH or installation unhealthy, further action required..."
    fi
}

cd "${WORKDIR}";

perl "${WORKDIR}/install-tl" --profile="${TEX_PROFILE}" --repository="${TEX_REPOSITORY}";

# Symlink to 

# `\d` class doesn't exist for basic `grep`, use `0-9`, which is much more
# portable. Finding the initial dir is very fast, but looking through everything
# else afterwards might take a while. Therefore, print and quit after first result.
# Path example: `/usr/local/texlive/2018/bin/x86_64-linux`
TEXLIVE_BIN_DIR=$(find / -type d -regextype grep -regex '.*/texlive/[0-9]\{4\}/bin/.*' -print -quit)

# -z test: string zero length?
if [ -z "$TEXLIVE_BIN_DIR" ]
then
    echoerr "Expected TeXLive installation dir not found and TeXLive installation did not modify PATH automatically."
    echoerr "Exiting."
    exit 1
fi

echo "Found TeXLive binaries at $TEXLIVE_BIN_DIR"
echo "Trying native TeXLive symlinking using tlmgr..."

# To my amazement, `tlmgr path add` can fail but still link successfully. So
# check if PATH is OK despite that command failing.
"$TEXLIVE_BIN_DIR"/tlmgr path add || \
    echoerr "Command borked, checking if it worked regardless..."

check_path || \
	echoerr "Symlinking using tlmgr did not succeed, trying manual linking..."

# "String contains", see: https://stackoverflow.com/a/229606/11477374
if [[ ! ${PATH} == *${SYMLINK_DESTINATION}* ]]
then
    # Should never get here, but make sure.
    echoerr "Symlink destination ${SYMLINK_DESTINATION} not in PATH (${PATH}), exiting."
    exit 1
fi

echo "Symlinking TeXLive binaries in ${TEXLIVE_BIN_DIR}"
echo "to a directory (${SYMLINK_DESTINATION}) found on PATH (${PATH})"

# Notice the slash and wildcard.
ln \
    --symbolic \
    --verbose \
    --target-directory="$SYMLINK_DESTINATION" \
    "$TEXLIVE_BIN_DIR"/*

check_path

