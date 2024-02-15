FROM mambaorg/micromamba:1.5.6
RUN micromamba install -y -n base -c conda-forge conda-pack
ARG CONDA_ENV_FILE
COPY ${CONDA_ENV_FILE} environment.yaml
RUN micromamba create -y -f environment.yaml && \
    micromamba clean --all --yes