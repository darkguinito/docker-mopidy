
# Project Ecosystem

- Music server [mopidy](https://github.com/mopidy/mopidy)
- Broadcaster [snapcast](https://github.com/badaix/snapcast)
- FrontEnd [muse](https://github.com/cristianpb/muse)

# Known limitations

Not fully configurable by environment variable


# Crosscompile docker image for v7

Good article (thanks to @artur.klauser):
[medium](https://medium.com/@artur.klauser/building-multi-architecture-docker-images-with-buildx-27d80f7e2408)

## First start docker with qemu

``` bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

## Second build for the targeted platform and push to dockerhub
``` bash
docker buildx build -t "docker-registry.home/darkinito/mopidy:latest"  --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 --push .
```

## Private docker registry

Until now, the only way i found, to use private docker registry is to following  instruction from @[klo2k](https://github.com/klo2k) [here](https://github.com/docker/buildx/issues/80#issuecomment-533844117)
If you know an easiest/better way i'm interested

![](https://media1.tenor.com/images/01fff8ee695eb1e398eedc8dc900b3b7/tenor.gif)

Use environment variable to simplify configuration

It may be overkill to defined SNAPSERVER and SNAPCAST.
SNAPCAST variable is only use by (the brilliant) [Muse](https://github.com/cristianpb/muse) frontend application, in case mopidy, which is run on server side, and muse, on client side (i suppose), does not have the same network .

variable          | default   | Description
:----------------:|:---------:|:---
SNAPSERVER_HOST   | localhost | Snapcast server hostname from server side
SNAPSERVER_PORT   | 4953      | Snapcast server audio tcp port
SNAPSCAST_HOST    | localhost | Snapcast server hostname from client (frontend muse) side
SNAPCAST_PORT     | 1780      | Snapcast jsonrpc websocket endpoint for control clients
SNAPCAST_SSL      | false     |
VOLUME_PERCENTAGE | 50        | Mopidy default volume level 50%
DEFAULT_ROOT_PATH | muse      | http server root path
MEDIA_DIRS        | /         | Path to media folder
MOPIDY_HOST       | localhost |
MOPIDY_PORT       | 1780      |
MOPIDY_SSL        | false     |

## Use it

``` bash
docker run --rm -d              \
    -p 6680:6680                \
    -e SNAPSERVER_HOST=snapcast \
    -e SNAPSERVER_PORT=4953     \
    -e SNAPSCAST_HOST=snapcast  \
    -e SNAPCAST_PORT=1780       \
    -e SNAPCAST_SSL=false       \
    -e VOLUME_PERCENTAGE=50     \
    -e DEFAULT_ROOT_PATH=muse   \
    -e MEDIA_DIRS=/mnt/music    \
    -e MOPIDY_HOST=localhost    \
    -e MOPIDY_PORT=1780         \
    -e MOPIDY_SSL=false         \
    -v ./data:/mnt/music        \
    darkinito/mopidy:latest
```

# Example

WIP

- [docker compose](https://github.com/darkguinito/docker-mopidy/blob/master/docker-compose.yml)
- [kubernetes](https://github.com/darkguinito/SaC/tree/master/mopidy)

