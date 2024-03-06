FROM mambaorg/micromamba:1.5.6
RUN micromamba install -y -n base -c conda-forge conda-pack
ARG CONDA_ENV_FILE
COPY ${CONDA_ENV_FILE} environment.yaml
RUN micromamba create -y -n venv -f environment.yaml && \
    micromamba clean --all --yes

RUN \
    git clone --depth 1 https://github.com/acolite/acolite.git && \
    # Acolite doesn't run on Python 3.12 yet
    sed -i 's/- python=3$/- python<=3.11/' acolite/environment.yml && \
    micromamba install -y -n venv -f ./acolite/environment.yml && \
    site_package_dir="$(/opt/conda/envs/venv/bin/python -c  "import site; print(''.join(site.getsitepackages()))")" && \
    cp ./acolite/acolite -r "$site_package_dir" && \
    cp ./acolite/config -r "$site_package_dir" && \
    cp ./acolite/data -r "$site_package_dir" \
