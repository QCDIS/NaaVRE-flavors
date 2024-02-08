FROM condaforge/mambaforge:23.3.1-1

RUN conda install -c conda-forge conda-merge conda-pack

ARG CONDA_ENV_FILE

COPY ${CONDA_ENV_FILE} environment.yaml
RUN mamba env create -n venv -f environment.yaml

ENV PATH /opt/conda/envs/venv/bin:$PATH
SHELL ["conda", "run", "-n", "venv", "/bin/bash", "-c"]
RUN echo "conda activate venv" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

RUN conda-pack -n venv -o /tmp/env.tar && \
    mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
    rm /tmp/env.tar
RUN /venv/bin/conda-unpack
