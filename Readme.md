# a-yasui/docker-texlive-ja-addition-fonts

Minimal LuaLaTeX Live image for Japanese based on debian.

Forked from umireon/docker-texci (under the MIT License) And https://github.com/a-yasui/docker-alpine-texlive-ja-addition-fonts (under the MIT License)

[![dockeri.co](https://dockeri.co/image/atyasu/docker-texlive-ja-addition-fonts)](https://hub.docker.com/r/atyasu/docker-texlive-ja-addition-fonts)

# Usage

```shell
$ docker pull atyasu/alpine-texlive-ja-addition-fonts:year-2020
$ docker run --rm -it -v $PWD:/workdir atyasu/alpine-texlive-ja-addition-fonts lualatex
```

# Font

IPA : https://moji.or.jp/ipafont/
Hack : https://sourcefoundry.org/hack/

# Samples

```
cd sample;
make all;
```

## References

- [吾輩は猫である -- 青空文庫](https://www.aozora.gr.jp/cards/000148/files/789_14547.html)
- [LuaTex-ja の使い方 -- ja.osdn.net](https://ja.osdn.net/projects/luatex-ja/wiki/LuaTeX-ja%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9)
- [LuaLATEX-ja用jclasses互換クラス ltjclasses.pdf](http://mirrors.ibiblio.org/CTAN/macros/luatex/generic/luatexja/doc/ltjclasses.pdf)

# License

MIT (c) a-yasui
