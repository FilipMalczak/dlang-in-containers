# dlang-in-containers

DLang is notoriously ugly when it comes to complilation (note: that's my opinion,
you can disagree and still benefit from this). Handling compiler and DUB versions
is not that easy.

Fortunately, we can freeze these versions and encapsulate the compilation
process in an OCI container. 

**This repo is intended to be forked, then tweaked for your needs**. Out of the
box you get simplest structure for DUB, README (here we are, aren't we?), 
LICENSE (MIT by default, so fork away and relicense as you wish), Dockerfile 
(you probably won't need to touch it) and couple of utility scripts.

## Dockerfile

As said, you probably won't touch it. It will copy the whole repo to the container
derived from dmd image, build the project, then copy the executable to another
image. That way we have rich compilation directory, but a neat, single executable
in the runtime. The executable is stored in `/dapp` directory (which is also
the WORKDIR). The executable name is taken as `APP_NAME` build argument with no
default. **If you don't provide it manually, it will go bonkers**; OTOH if
you use the following scripts, they will handle naming for you.

> Currently the base image is `dlangchina/dlang-dmd:2.097.1`. It is derived
> from sid Debian, which sorta matters when describing scripts.

## Scripts

There are 2 scripts:

```bash
./build.sh TAG
./extract.sh TAG
```

The former will take the Dockerfile in the current directory and build it.
Default Dockerfile was described above. After building, newly created image
will be tagged with the argument.

The latter will spin up a container for the tag passed as an argument
and copy the executable out of it into current directory. That executable
should be... well, executable on your host right after the script exits.

Both scripts use `APP_NAME`  envvar to control the executable name. By default
it is simply `app`. Unfortunately, installing jq on Debian is an overkill just
to extract the name from dub. **Keeping the name in `dub.json` and the one you
use as an `APP_NAME` envvar is your job**.

There are some more envvars that these scripts use:
- `build.sh`
  - `APP_NAME`
    - well, duh
  - `IMAGE_BUILD`
    - command used to build an image from Dockerfile; expects to be docker drop-in
    - defaults to `docker build`
- `extract.sh`
  - `APP_NAME`
    - well, duh
  - `CONTAINER_CREATE`, `CONTAINER_RM`
    - in the same fashion, docker drop-in replacements with default of
      `docker create` and `docker rm` respectively
  - `FILE_CP`
    - used to copy file between a running container and host
    - defaults to `docker cp`
  - `MAKE_NAME`
    - used to generate a container name; it doesn't need to satisfy any interface,
      it will simply be executed within shell and its stdout will be the container
      name
    - defaults to `date +%s` (epoch number)

### Build, extract, run on host

```bash

export APP_NAME=my-app
export TAG=$APP_NAME:0.0.42-SNAPSHOT

./build.sh $TAG
./extract.sh $TAG
./APP_NAME
```

### Build, run in container

```bash

export APP_NAME=my-app
export TAG=$APP_NAME:0.0.42-SNAPSHOT

./build.sh $TAG``
docker run $TAG
```


