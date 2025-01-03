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

WORKDIR /workdir

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

RUN apt install -y unzip
COPY Hack-v3.003-ttf.zip .
RUN unzip Hack-v3.003-ttf.zip \
    && mkdir -p /usr/share/fonts \
    && cp -R ttf /usr/share/fonts/Hackfont \
    && rm -rf Hack-v3.003-ttf.zip ttf

COPY IPAexfont00401.zip .
RUN unzip IPAexfont00401.zip \
    && cp -R IPAexfont00401 /usr/share/fonts/IPA \
    && rm -rf IPAexfont00401.zip IPAexfont00401

## Make Font Caches
RUN fc-cache -fv && mktexlsr && luaotfload-tool -v -vvv -u
RUN apt remove -y unzip && apt clean -y && rm -rf /var/lib/apt/lists/*

CMD ["sh"]
