VERSION=latest

multi-arch:
	docker buildx build --platform linux/amd64,linux/arm64 -t atyasu/alpine-texlive-ja-addition-fonts:year-2020 --push .

aarch64:
	docker build -t atyasu/alpine-texlive-ja-addition-fonts:year-2020 -f Dockerfile.aarch64 --no-cache .

x86_64:
	docker build -t atyasu/alpine-texlive-ja-addition-fonts:year-2020  -f Dockerfile.x86_64 --no-cache .
