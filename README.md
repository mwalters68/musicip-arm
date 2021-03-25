# musicip-arm
MusicIP server for ARM using [box86](https://github.com/ptitSeb/box86) to provide x86 emulation for the MusicMagicServer.exe binary.  Based on https://github.com/ptoulouse/docker-musicip and [Spicefly](https://www.spicefly.com/).

## Build Details
The image uses a multi-stage build with the first step being used to compile box86 and the resulting binary being copied to the final image in the second stage.  Ubuntu:20.04 is used as the base.

This example build command uses docker buildx onto specify the armhf platform which is required for the box86 compilation when running on an aarch64 host.  This has been tested on an Odroid N2 running Ubuntu 20.04
```shell
# git clone https://github.bmc.com/walters68/musicip-arm
# cd musicip-arm
# docker buildx build --platform=armhf -t musicip-arm .
```
## Prebuilt Image
An image is available from the [Docker Hub](https://hub.docker.com/r/mwalters68/musicip-arm).
