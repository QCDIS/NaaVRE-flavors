ARG NAAVRE_VERSION

FROM qcdis/n-a-a-vre:${NAAVRE_VERSION}

ARG CONDA_ENV_FILE

COPY ${CONDA_ENV_FILE} environment.yaml
RUN mamba env create -f environment.yaml

RUN conda run -n quadfavl bash -c "export PKG_LIBS=\""'$(pkg-config --libs proj) $(gsl-config --libs)'"\"; Rscript -e \"install.packages(\\\"vol2birdR\\\", repos=\\\"https://cran.r-project.org\\\"); library(\\\"vol2birdR\\\")\""
