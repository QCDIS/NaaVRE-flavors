ARG NAAVRE_VERSION
FROM qcdis/n-a-a-vre:${NAAVRE_VERSION}

ARG CONDA_ENV_FILE

COPY ${CONDA_ENV_FILE} environment.yaml
RUN mamba env create -f environment.yaml

RUN \
    git clone --depth 1 https://github.com/acolite/acolite.git && \
    # Acolite doesn't run on Python 3.12 yet
    sed -i 's/- python=3$/- python<=3.11/' acolite/environment.yml && \
    mamba env update --name lter-life-wadden-py --file ./acolite/environment.yml && \
    site_package_dir="$(/opt/conda/envs/lter-life-wadden-py/bin/python -c  "import site; print(''.join(site.getsitepackages()))")" && \
    cp ./acolite/acolite -r "$site_package_dir" && \
    cp ./acolite/config -r "$site_package_dir" && \
    cp ./acolite/data -r "$site_package_dir"
