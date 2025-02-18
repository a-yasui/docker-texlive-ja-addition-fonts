#!/usr/bin/env bash

set -ueo pipefail;

TEXLIVE_BIN_DIR=$(find / -type d -regextype grep -regex '.*/texlive/[0-9]\{4\}/bin/.*' -print -quit)

[[ -e "texmf.cnf" ]] && cp "texmf.cnf" "${TEXLIVE_BIN_DIR}/texmf.cnf"
[[ -e "texmfcnf.lua" ]] && cp "texmfcnf.lua" "${TEXLIVE_BIN_DIR}/texmfcnf.lua"


fc-cache -fv && mktexlsr && luaotfload-tool -v -vvv -u;
