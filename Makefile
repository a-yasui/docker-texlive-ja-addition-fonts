VERSION=year-2023

multi-arch:
	docker buildx build --platform linux/amd64,linux/arm64 -t atyasu/docker-texlive-ja-addition-fonts:year-2023 --push .
