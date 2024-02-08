# NaaVRE flavors

NaaVRE flavors extend the base edition by adding extra dependencies and
publishing two docker images:

- `naavre-jupyter-myflavor`, the NaaVRE Jupyter Lab image, based on `qcdis/n-a-a-vre`
- `naavre-cell-myflavor`, the NaaNaaVRE cell base image


Each flavor corresponds to a directory `./flavors/myflavor`, with the following
structure:

```txt
myflavor
├── environment.yaml              # Conda environment with `name: myflavor`
├── tests                         #
│    └── tests.sh                 # Test script run in naavre-cell-myflavor
├── [naavre-cell.Dockerfile]      # Optional override to docker/naavre-cell.Dockerfile
└── [naavre-jupyter.Dockerfile]   # Optional override to docker/naavre-jupyter.Dockerfile
```
