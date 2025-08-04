FROM mambaorg/micromamba:1.5.6
RUN micromamba install -y -n base -c conda-forge conda-pack
ARG CONDA_ENV_FILE
COPY ${CONDA_ENV_FILE} environment.yaml
RUN micromamba create -y -n venv -f environment.yaml && \
    micromamba clean --all --yes

RUN /opt/conda/envs/venv/bin/git clone --depth 1 --branch 20250114.0 https://github.com/acolite/acolite.git && \
    site_package_dir="$(/opt/conda/envs/venv/bin/python -c  "import site; print(''.join(site.getsitepackages()))")" && \
    cp ./acolite/acolite -r "$site_package_dir" && \
    cp ./acolite/config -r "$site_package_dir" && \
    cp ./acolite/data -r "$site_package_dir"
RUN /opt/conda/envs/venv/bin/R -e "devtools::install_github('krietsch/tools4watlas@952cb1038c862075bb2df2dfc061e2df87b04340', dependencies = FALSE)"
RUN /opt/conda/envs/venv/bin/R -e "library('tools4watlas')"
RUN /opt/conda/envs/venv/bin/R -e "devtools::install_github('allertbijleveld/SIBES@24d3f06418a8aca77db4e7fbef66c45dc55873f8', dependencies = FALSE)"
RUN /opt/conda/envs/venv/bin/R -e "library('SIBES')"
RUN /opt/conda/envs/venv/bin/R -e "devtools::install_github('TempSED/TempSED@79ecf0e2f9473c3e5e35cf53bc87d15389f2e68c', depend = TRUE)"
RUN /opt/conda/envs/venv/bin/R -e "require('TempSED')"
