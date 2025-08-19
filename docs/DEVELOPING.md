# Development Documentation <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [Docker](#docker)
  - [Build the container](#build-the-container)
  - [Run the container](#run-the-container)

## Docker

This repository includes Docker images for building Neovim with my custom config in a container environment. The Dockerfiles can be found in the [containers/](./containers/) path. For example, [`deb.Dockerfile`](./containers/deb.Dockerfile) builds `neovim` on a Debian base and installs the configuration for Debian.

The containers set up an environment to run [`install.sh`](./scripts/linux/install.sh), and can be used to test my `neovim` setup across multiple platforms.

### Build the container

To build the container, run the [`build-deb-img.sh`](./scripts/docker/build-deb-img.sh) (for Debian) or [`build-rpm-img.sh`](./scripts/docker/build-rpm-img.sh) (for Fedora) script.

For example, the `build-deb-img.sh` script (note: you should run this script from the root of the repository):

```shell
./scripts/docker/build-deb-img.sh
```

You can also manually build the command (note: add `--progress=plain` to the end of the docker build command to see all build output):

```shell
## Enable CONTAINER_ENV and set a build path for Neovim before running container
#  This example builds the deb.Dockerfile Debian container environment
CONTAINER_ENV=1 NEOVIM_MAKE_BUILD_DIR="/tmp/build" docker build -f ./containers/deb.Dockerfile -t neovim-buildtest .
```

### Run the container

After building the Docker container, you can run it with:

```shell
docker exec --rm -it nvim-buildtest /bin/bash
```

Once you're in the container, open neovim with `nvim`. The `Lazy` installer should kick off and build the configuration. After this first execution, each subsequent run will launch immediately, until the container is rebuilt.
