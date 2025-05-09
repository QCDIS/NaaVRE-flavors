ARG NAAVRE_VERSION

FROM adokter/vol2bird:0.5.0 AS vol2bird

RUN apt-get update && \
    apt-get install --no-install-recommends -y libconfuse-dev libhdf5-dev gcc g++ wget unzip make cmake zlib1g-dev python-dev python-numpy libproj-dev flex-old file && \
    apt-get install -y git git-lfs && \
    apt-get install -y libgsl-dev && \
    apt-get install -y libbz2-dev bison byacc && \
    apt autoclean -y && \
    apt autoremove -y

FROM qcdis/n-a-a-vre:${NAAVRE_VERSION}

ARG CONDA_ENV_FILE

COPY ${CONDA_ENV_FILE} environment.yaml
RUN mamba env create -f environment.yaml

RUN /opt/conda/envs/quadfavl/bin/R -e "install.packages('suntools', repos='https://cran.r-project.org')"
RUN /opt/conda/envs/quadfavl/bin/R -e "install.packages('bioRad', repos='https://cran.r-project.org')"
RUN /opt/conda/envs/quadfavl/bin/R -e "library('bioRad')"
RUN /opt/conda/envs/quadfavl/bin/R -e "devtools::install_github('aloftdata/getRad')"
RUN /opt/conda/envs/quadfavl/bin/R -e "install.packages('vol2birdR', repos='https://cran.r-project.org')"

COPY --from=vol2bird /opt/radar/ /opt/radar/
COPY --from=vol2bird /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/radar/lib:/opt/radar/rave/lib:/opt/radar/rsl/lib:/opt/radar/vol2bird/lib:/usr/lib/x86_64-linux-gnu
ENV PATH=${PATH}:/opt/radar/vol2bird/bin:/opt/radar/rsl/bin

