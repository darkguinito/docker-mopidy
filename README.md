# Crosscompile docker image for v7

Good article explaining all i know (thanks to @artur.klauser):
[medium](https://medium.com/@artur.klauser/building-multi-architecture-docker-images-with-buildx-27d80f7e2408)

## First start docker with qemu

``` bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

## Second build for the targeted platform and push to dockerhub
``` bash
docker buildx build -t "darkinito/mopidy:latest"  --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 --push .
```
