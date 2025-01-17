FROM condaforge/mambaforge:24.9.2-0 AS build

ARG DEBIAN_FRONTEND=noninteractive

RUN conda install -c conda-forge conda-pack conda-merge
COPY flavors/vol2bird/biorad-environment.yaml environment.yaml

RUN mamba env update --name venv -f environment.yaml

SHELL ["conda", "run", "--no-capture-output", "-n", "venv", "/bin/bash", "-c"]

RUN R -e "install.packages('suntools', repos='https://cran.r-project.org')"
RUN R -e "install.packages('bioRad', repos='https://cran.r-project.org')"
RUN R -e "library('bioRad')"