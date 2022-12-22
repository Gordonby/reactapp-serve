#Node18 base image, serve 14
docker build . -t ghcr.io/gordonby/gordsnodeserveapp:n18s14port3000

$env:DOCKER_BUILDKIT=0; docker build . -t ghcr.io/gordonby/gordsnodeserveapp:n18s14port1025 --build-arg PORT_ARG=1025