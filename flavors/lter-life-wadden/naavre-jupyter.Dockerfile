ARG NAAVRE_VERSION
FROM qcdis/n-a-a-vre:${NAAVRE_VERSION}

ARG CONDA_ENV_FILE
COPY ${CONDA_ENV_FILE} environment.yaml
RUN mamba env create -f environment.yaml

RUN /opt/conda/envs/lter-life-wadden/bin/git clone --depth 1 --branch 20250114.0 https://github.com/acolite/acolite.git && \
    site_package_dir="$(/opt/conda/envs/lter-life-wadden/bin/python -c  "import site; print(''.join(site.getsitepackages()))")" && \
    cp ./acolite/acolite -r "$site_package_dir" && \
    cp ./acolite/config -r "$site_package_dir" && \
    cp ./acolite/data -r "$site_package_dir"

COPY ./flavors/lter-life-wadden/install_packages.R .
RUN conda run -n lter-life-wadden bash -c "Rscript install_packages.R"
