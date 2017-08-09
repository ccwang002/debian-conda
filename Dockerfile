FROM debian:stretch-slim
LABEL maintainer="Liang-Bo Wang <liang-bo.wang@wustl.edu>"

ARG DEBIAN_FRONTEND=noninteractive

# Upgrade APT
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Configure locale and timezone
RUN apt-get update && apt-get install -y locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure -f noninteractive locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Install miniconda3 at /opt/conda
RUN apt-get update \
    && apt-get -y install --no-install-recommends curl bzip2 ca-certificates \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /opt/conda \
    && rm -rf /tmp/miniconda.sh \
    && apt-get -y remove curl bzip2 \
    && apt-get -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && /opt/conda/bin/conda clean --all --yes

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8" \
    PATH="/opt/conda/bin:${PATH}"                               \
    SHELL="/bin/bash"

RUN conda config --add channels conda-forge \
    && conda config --add channels bioconda
