cd reactapp-serve

#Node18 base image, serve 14
docker build . -t ghcr.io/gordonby/gordsnodeserveapp:n18s14port3000
docker push ghcr.io/gordonby/gordsnodeserveapp:n18s14port3000

#Dockerfile with buildkit debugging...  Node18 base image, serve 14 - on port 1025
$env:DOCKER_BUILDKIT=0; docker build . -t ghcr.io/gordonby/gordsnodeserveapp:n18s14port1025 --build-arg PORT_ARG=1025
docker push ghcr.io/gordonby/gordsnodeserveapp:n18s14port1025

docker build . -t ghcr.io/gordonby/gordsnodeserveapp:n10s14port1025 --build-arg PORT_ARG=1025 nodeVersion=10.15.0