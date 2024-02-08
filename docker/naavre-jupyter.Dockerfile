ARG NAAVRE_VERSION
FROM qcdis/n-a-a-vre:${NAAVRE_VERSION}

ARG CONDA_ENV_FILE

COPY ${CONDA_ENV_FILE} environment.yaml
RUN mamba env create -f environment.yaml
