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
