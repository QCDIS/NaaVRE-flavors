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

### Jupyter Lab

Set the Dockerfile to the `naavre-jupyter.Dockerfile`:

```bash
dockerfile=./docker/naavre-jupyter.bioRad.Dockerfile
```

Set the conda environment file to the flavor's `environment.yaml`. For example for building the phytoplankton flavor:

```bash
CONDA_ENV_FILE=./flavors/phytoplankton/environment.yaml
```

Set the NAAVRE_VERSION to the desired version of the NaaVRE base image. For example for building using the latest version:


```bash
NAAVRE_VERSION=latest
```

Run the build command:

```bash
docker build -t naavre-jupyter-phytoplankton -f $dockerfile --build-arg CONDA_ENV_FILE=$CONDA_ENV_FILE --build-arg NAAVRE_VERSION=$NAAVRE_VERSION .
```

To run the container:

```bash
docker run -it -p 8888:8888 --env-file ~/Downloads/notbooks/docker_VARS naavre-jupyter-phytoplankton /bin/bash -c "source /venv/bin/activate && /tmp/init_script.sh && jupyter lab --debug --watch --NotebookApp.token='' --NotebookApp.ip='0.0.0.0' --NotebookApp.allow_origin='*' --collaborative"
```