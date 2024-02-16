VERSION=latest

multi-arch:
	docker buildx build --platform linux/amd64,linux/arm64 -t atyasu/docker-texlive-ja-addition-fonts:latest --push .
