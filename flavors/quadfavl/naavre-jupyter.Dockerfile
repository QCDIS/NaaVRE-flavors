ARG NAAVRE_VERSION
FROM qcdis/n-a-a-vre:${NAAVRE_VERSION}

ARG CONDA_ENV_FILE

COPY ${CONDA_ENV_FILE} environment.yaml
RUN mamba env create -f environment.yaml

ARG FLAVOR_NAME=quadfavl
RUN /opt/conda/envs/${FLAVOR_NAME}/bin/R -e "install.packages('bioRad', repos='https://cran.r-project.org')"
RUN /opt/conda/envs/${FLAVOR_NAME}/bin/R -e "library('bioRad')"
