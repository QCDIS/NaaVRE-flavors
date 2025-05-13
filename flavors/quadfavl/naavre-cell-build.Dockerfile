FROM mambaorg/micromamba:1.5.6
RUN micromamba install -y -n base -c conda-forge conda-pack
ARG CONDA_ENV_FILE
COPY ${CONDA_ENV_FILE} environment.yaml
RUN micromamba create -y -n venv -f environment.yaml && \
    micromamba clean --all --yes

RUN micromamba run -n venv bash -c "export PKG_LIBS=\""'$(pkg-config --libs proj) $(gsl-config --libs)'"\"; Rscript -e \"install.packages(\\\"vol2birdR\\\", repos=\\\"https://cran.r-project.org\\\"); library(\\\"vol2birdR\\\")\""
