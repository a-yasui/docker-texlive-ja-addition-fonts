VERSION=latest

multi-arch:
	docker buildx build --platform linux/amd64,linux/arm64 -t atyasu/docker-texlive-ja-addition-fonts:latest --push .

aarch64:
	docker build -t atyasu/docker-texlive-ja-addition-fonts:latest -f Dockerfile.aarch64 .
	docker push atyasu/docker-texlive-ja-addition-fonts:latest 

x86_64:
	docker build -t atyasu/docker-texlive-ja-addition-fonts:latest  -f Dockerfile.x86_64 .
