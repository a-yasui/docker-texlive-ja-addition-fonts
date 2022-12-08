
multi-arch:
	docker buildx build --platform linux/amd64,linux/arm64 -t atyasu/docker-texlive-ja-addition-fonts:year-2021 --push .

aarch64:
	docker build -t atyasu/docker-texlive-ja-addition-fonts:year-2021 -f Dockerfile.aarch64 .
	docker push atyasu/docker-texlive-ja-addition-fonts:year-2021 

x86_64:
	docker build -t atyasu/docker-texlive-ja-addition-fonts:year-2021  -f Dockerfile.x86_64 .
