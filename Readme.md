# a-yasui/docker-texlive-ja-addition-fonts

LuaLaTeX Live image for Japanese based on debian.

Forked from umireon/docker-texci (under the MIT License) And https://github.com/a-yasui/docker-alpine-texlive-ja-addition-fonts (under the MIT License)

[![dockeri.co](https://dockeri.co/image/atyasu/docker-texlive-ja-addition-fonts)](https://hub.docker.com/r/atyasu/docker-texlive-ja-addition-fonts)




# Usage

```shell
$ docker pull atyasu/docker-texlive-ja-addition-fonts:latest
$ docker run --rm -it -v $PWD:/workdir atyasu/docker-texlive-ja-addition-fonts lualatex
```

## Yearly

- 2024 : docker pull atyasu/docker-texlive-ja-addition-fonts:year-2024
- 2023 : docker pull atyasu/docker-texlive-ja-addition-fonts:year-2023
- 2022 : docker pull atyasu/docker-texlive-ja-addition-fonts:year-2022
- 2021 : docker pull atyasu/docker-texlive-ja-addition-fonts:year-2021
- 2020 : docker pull atyasu/docker-texlive-ja-addition-fonts:year-2020

# Font

- 原ノ味フォント：https://github.com/trueroad/HaranoAjiFonts
- IPA : https://moji.or.jp/ipafont/
- Hack : https://sourcefoundry.org/hack/

# Samples

```
cd sample;
make all;
```

## 他の DockerImage に取り込む

ディスク容量はまぁまぁしんどい物だけど、他の環境に移す時はこんな感じで使えば動きました。

```Dockerfile
FROM atyasu/docker-texlive-ja-addition-fonts:latest AS lualatex

FROM debian:stable
ARG TARGETPLATFORM
ARG BUILDPLATFORM

ARG USER="workuser"

RUN useradd --create-home ${USER}
RUN mkdir "/workdir" &&  mkdir "/home/${USER}/bin"

COPY --from=lualatex /usr/local/texlive /usr/local/texlive
COPY --from=lualatex /workdir /workdir

WORKDIR "/home/${USER}"

RUN ln --symbolic --verbose --target-directory="bin" "$(find / -type d -regextype grep -regex '.*/texlive/[0-9]\{4\}/bin/.*' -print -quit)/"*

USER ${USER}
ENV PATH="/home/${USER}/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

CMD ["sh"]
```


## References

- [吾輩は猫である -- 青空文庫](https://www.aozora.gr.jp/cards/000148/files/789_14547.html)
- [LuaTex-ja の使い方 -- ja.osdn.net](https://ja.osdn.net/projects/luatex-ja/wiki/LuaTeX-ja%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9)
- [LuaLATEX-ja用jclasses互換クラス ltjclasses.pdf](http://mirrors.ibiblio.org/CTAN/macros/luatex/generic/luatexja/doc/ltjclasses.pdf)

# License

MIT (c) a-yasui
