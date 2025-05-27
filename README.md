# NaaVRE flavors

NaaVRE flavors extend the base edition by adding extra dependencies and
publishing three docker images:

- `naavre-jupyter-myflavor`, the NaaVRE Jupyter Lab image, based on `qcdis/n-a-a-vre` (skipped `python` and `r` flavors). This is the image for the users Jupyter Lab instances, containing dependencies for notebook execution.
- `naavre-cell-build-myflavor`, the base images for the `build` stage of NaaVRE cells. This image contains conda dependencies for containerized cells execution.
- `naavre-cell-runtime-myflavor`, the base images for the `runtime` stage of NaaVRE cells. This image contains other dependencies (system, manually added, etc.) for containerized cells execution.

Each flavor corresponds to a directory `./flavors/myflavor`, with the following
structure:

```txt
myflavor
├── environment.yaml                  # Conda environment with `name: myflavor`
├── flavor_config.yaml                # Build configuration
├── tests                             #
│    └── tests.sh                     # Test script run in naavre-cell-myflavor
├── [naavre-cell-build.Dockerfile]    # Optional override to docker/naavre-cell-build.Dockerfile
├── [naavre-cell-runtime.Dockerfile]  # Optional override to docker/naavre-cell-runtime.Dockerfile
└── [naavre-jupyter.Dockerfile]       # Optional override to docker/naavre-jupyter.Dockerfile
```


## Build and Run Containers Locally

### Build

Use the helper script:

```console
$ ./build-local.sh -h
Usage: ./build-local.sh [-n] [-t target] flavor

-h,--help           print help and exit
-n,--dry-run        print the commands that would be executed and exit
-t,--target target  build target (options: jupyter, cell-build, cell-runtime,
                    cell-test, cell-all, all; default: all)
flavor              flavor name
```

Example: all images for the vol2bird flavor:

```console
$ ./build-local.sh vol2bird -t all
Building images...
docker build . -f ./flavors/vol2bird/naavre-jupyter.Dockerfile --build-arg CONDA_ENV_FILE=./flavors/vol2bird/environment.yaml --build-arg NAAVRE_VERSION=latest -t naavre-jupyter-vol2bird:local
[+] Building 1.1s (23/23) FINISHED                                                                      docker:default
 => ...
docker build . -f ./docker/naavre-cell-build.Dockerfile --build-arg CONDA_ENV_FILE=./flavors/vol2bird/environment.yaml --build-arg NAAVRE_VERSION=latest -t naavre-cell-build-vol2bird:local
[+] Building 1.0s (9/9) FINISHED                                                                        docker:default
 => ...
docker build . -f ./flavors/vol2bird/naavre-cell-runtime.Dockerfile --build-arg CONDA_ENV_FILE=./flavors/vol2bird/environment.yaml --build-arg NAAVRE_VERSION=latest -t naavre-cell-runtime-vol2bird:local
[+] Building 0.5s (15/15) FINISHED                                                                      docker:default
 => ...
docker build . -f ./docker/cell-test.Dockerfile --build-arg BUILD_IMAGE=naavre-cell-build-vol2bird:local --build-arg RUNTIME_IMAGE=naavre-cell-runtime-vol2bird:local -t naavre-cell-test-vol2bird:local
[+] Building 0.3s (11/11) FINISHED                                                                      docker:default
 => ...

Built images:
naavre-jupyter-vol2bird:local
naavre-cell-build-vol2bird:local
naavre-cell-runtime-vol2bird:local
naavre-cell-test-vol2bird:local
```

Example: jupyter image for the vol2bird flavor:

```console
$ ./build-local.sh vol2bird -t jupyter
Building images...
docker build . -f ./flavors/vol2bird/naavre-jupyter.Dockerfile --build-arg CONDA_ENV_FILE=./flavors/vol2bird/environment.yaml --build-arg NAAVRE_VERSION=latest -t naavre-jupyter-vol2bird:local
[+] Building 0.7s (23/23) FINISHED                                                                      docker:default
 => ...

Built images:
naavre-jupyter-vol2bird:local
```

Example: all cell images for the vol2bird flavor:

```console
$ ./build-local.sh vol2bird -t cell-all
Building images...
docker build . -f ./docker/naavre-cell-build.Dockerfile --build-arg CONDA_ENV_FILE=./flavors/vol2bird/environment.yaml --build-arg NAAVRE_VERSION=latest -t naavre-cell-build-vol2bird:local
[+] Building 0.7s (9/9) FINISHED                                                                        docker:default
 => ...
docker build . -f ./flavors/vol2bird/naavre-cell-runtime.Dockerfile --build-arg CONDA_ENV_FILE=./flavors/vol2bird/environment.yaml --build-arg NAAVRE_VERSION=latest -t naavre-cell-runtime-vol2bird:local
[+] Building 0.7s (15/15) FINISHED                                                                      docker:default
 => ...
docker build . -f ./docker/cell-test.Dockerfile --build-arg BUILD_IMAGE=naavre-cell-build-vol2bird:local --build-arg RUNTIME_IMAGE=naavre-cell-runtime-vol2bird:local -t naavre-cell-test-vol2bird:local
[+] Building 0.3s (11/11) FINISHED                                                                      docker:default
 => ...

Built images:
naavre-cell-build-vol2bird:local
naavre-cell-runtime-vol2bird:local
naavre-cell-test-vol2bird:local
```

_Note: the `cell-test` target requires `cell-build` and `cell-runtime`. While the helper script allows to build only `cell-test`, it will fail if its dependencies haven’t previously been built. Use `cell-all` to build all three targets._

### Run

#### Jupyter Lab

Example for the vol2bird flavor (using [`docker_VARS` from the QCDIS/NaaVRE repo](https://github.com/QCDIS/NaaVRE/blob/main/docker/docker_VARS)):

```shell
docker run -it -p 8888:8888 --env-file /path/to/NaaVRE/docker/docker_VARS naavre-jupyter-vol2bird:local /bin/bash -c "source /venv/bin/activate && /tmp/init_script.sh && jupyter lab --debug --watch --NotebookApp.token='' --NotebookApp.ip='0.0.0.0' --NotebookApp.allow_origin='*' --collaborative"
```

#### Cell tests

Example for the vol2bird flavor:

```shell
./build-local.sh vol2bird -t cell-build, cell-runtime, cell-test
docker run -v ./flavors/vol2bird/tests/:/tests/ naavre-cell-test-vol2bird:local /bin/bash /tests/tests.sh
echo $?
```

Successful tests should output `0`.

#### Terminal
To run the flavor in a terminal:
```shell
docker run -it naavre-jupyter-[Flavor name]:local /bin/bash
```

> [!TIP]
> NaaVRE images are large and can quickly fill up your machine's storage.
> If needed, free-up space with `docker image prune [-a]` ([documentation](https://docs.docker.com/reference/cli/docker/image/prune/)).
