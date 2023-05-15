VERSION=year-2022

multi-arch:
	docker buildx build --platform linux/amd64,linux/arm64 -t atyasu/docker-texlive-ja-addition-fonts:year-2022 --push .

aarch64:
	docker build -t atyasu/docker-texlive-ja-addition-fonts:year-2022 -f Dockerfile.aarch64 .
	docker push atyasu/docker-texlive-ja-addition-fonts:year-2022 

x86_64:
	docker build -t atyasu/docker-texlive-ja-addition-fonts:year-2022  -f Dockerfile.x86_64 .
