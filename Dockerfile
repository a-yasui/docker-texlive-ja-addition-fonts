# Released under the MIT license
# https://opensource.org/licenses/MIT
#

FROM --platform=$TARGETPLATFORM debian:stable
ARG TARGETPLATFORM
ARG BUILDPLATFORM

LABEL org.opencontainers.image.authors="a.yasui@gmail.com"

ENV PATH=/usr/local/texlive/2024/bin/x86_64-linux:/usr/local/texlive/2024/bin/aarch64-linux:/usr/local/texlive/2025/bin/x86_64-linux:/usr/local/texlive/2025/bin/aarch64-linux:$PATH
ENV TZ=Asia/Tokyo
ENV MANPATH=/usr/local/texlive/2024/texmf-dist/doc/man:$MANPATH
ENV INFOPATH=/usr/local/texlive/2024/texmf-dist/doc/info:$INFOPATH
ENV LANG=C.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#
# Install And Build The TexLive
ARG INSTALL_TL_DIR="/install"
ARG INSTALL_TL_URL="https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
ARG INSTALL_TL_REPOSITORY="https://mirror.ctan.org/systems/texlive/tlnet/"
ARG TEX_PROFILE="${INSTALL_TL_DIR}/texlive.profile"

LABEL maintainer="a.yasui@gmail.com" \
      org.opencontainers.image.title="TexliveJaAdditionFonts" \
      org.opencontainers.image.description="LuaLaTeX Live image for Japanese based on debian." \
      org.opencontainers.image.version="latest" \
      org.opencontainers.image.source="https://github.com/a-yasui/docker-texlive-ja-addition-fonts" \
      org.opencontainers.image.licenses="MIT"

ARG USER="tex"
RUN useradd --create-home ${USER} && mkdir "${INSTALL_TL_DIR}"

WORKDIR $INSTALL_TL_DIR

## If Stable Release: Maybe, release date will be */04/20 cycle.
### install-tl-unx.tar.gz : https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2021/tlnet-final/install-tl-unx.tar.gz
### Repository : https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2021/
##
## If you use the Major version: Use to ctan link: https://mirror.ctan.org/systems/texlive/tlnet
### install-tl-unx.tar.gz : https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
### Repository : https://mirror.ctan.org/systems/texlive/tlnet

COPY mkcompile.sh /tmp/mkcompile.sh
RUN chmod +x /tmp/mkcompile.sh \
    && mkdir /tmp/install-tl-unx \
    && /tmp/mkcompile.sh $TARGETPLATFORM \
    && rm /tmp/mkcompile.sh

RUN apt update \
    && apt install -y perl wget xz-utils tar fontconfig libfreetype6 unzip \
    && apt clean -y \
    && wget -qO - https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/install-tl-unx --strip-components=1 \
    && /tmp/install-tl-unx/install-tl \
    --no-gui \
    --profile=/tmp/install-tl-unx/texlive.profile \
    --repository https://mirror.ctan.org/systems/texlive/tlnet/ \
    && tlmgr install \
    collection-basic collection-latex \
    collection-latexrecommended collection-latexextra \
    collection-fontsrecommended collection-langjapanese \
    collection-luatex latexmk \
    && rm -fr /tmp/install-tl-unx

## Install Fonts
COPY Hack-v3.003-ttf.zip IPAexfont00401.zip install-tl.sh .
RUN chmod +x install-tl.sh

## Install texLive
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y ca-certificates perl curl wget xz-utils tar libfreetype6 unzip \
  # DownLoad
  && wget -qO - "${INSTALL_TL_URL}" | tar -xz -C ${INSTALL_TL_DIR} --strip-components=1 \
  # Install
  && /${INSTALL_TL_DIR}/install-tl.sh "${INSTALL_TL_DIR}" "${TEX_PROFILE}" "${INSTALL_TL_REPOSITORY}" \
  # Install Fonts
  && apt-get install --no-install-recommends -y unzip fontconfig \
  && mkdir -p "/${USER}/.fonts" \
  && unzip Hack-v3.003-ttf.zip && cp -R ttf "/${USER}/.fonts/Hackfont" && rm -rf Hack-v3.003-ttf.zip ttf \
  && unzip IPAexfont00401.zip  && cp -R IPAexfont00401 "/${USER}/.fonts/IPA" && rm -rf IPAexfont00401.zip IPAexfont00401 \

  # CleanUp
  && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR "/${USER}"
RUN rm --recursive "${INSTALL_TL_DIR}"

USER ${USER}
RUN fc-cache -fv

# Load font cache, has to be done on each compilation otherwise
# ("luaotfload | db : Font names database not found, generating new one.").
# If not found, e.g. TeXLive 2012 and earlier, simply skip it. Will return exit code
# 0 and allow the build to continue.
# Warning: This is USER-specific. If the current `USER` for which we run this is not
# the container user, the font will be regenerated for that new user.
RUN luaotfload-tool --update || echo "luaotfload-tool did not succeed, skipping."

CMD ["sh"]
