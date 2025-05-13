ARG NAAVRE_VERSION

FROM qcdis/n-a-a-vre:${NAAVRE_VERSION}

ARG CONDA_ENV_FILE

COPY ${CONDA_ENV_FILE} environment.yaml
RUN mamba env create -f environment.yaml

RUN conda run -n quadfavl bash -c "export PKG_LIBS=\""'$(pkg-config --libs proj) $(gsl-config --libs)'"\"; Rscript -e \"install.packages(\\\"vol2birdR\\\", repos=\\\"https://cran.r-project.org\\\"); library(\\\"vol2birdR\\\")\""
RUN /opt/conda/envs/quadfavl/bin/R -e "install.packages('suntools', repos='https://cran.r-project.org')"
RUN /opt/conda/envs/quadfavl/bin/R -e "library('suntools')"
RUN /opt/conda/envs/quadfavl/bin/R -e "install.packages('lutz', repos='https://cran.r-project.org')"
RUN /opt/conda/envs/quadfavl/bin/R -e "library('lutz')"
RUN /opt/conda/envs/quadfavl/bin/R -e "install.packages('bioRad', repos='https://cran.r-project.org')"
RUN /opt/conda/envs/quadfavl/bin/R -e "library('bioRad')"
RUN /opt/conda/envs/quadfavl/bin/R -e "devtools::install_github('aloftdata/getRad')"
RUN /opt/conda/envs/quadfavl/bin/R -e "library('getRad')"
