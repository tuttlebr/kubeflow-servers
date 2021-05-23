
# Candidates
# nvcr.io/nvidia/tensorflow:20.09-tf2-py3
# nvcr.io/nvidia/pytorch:20.09-py3
# rapidsai/rapidsai:cuda11.0-runtime-ubuntu20.04-py3.8

ARG BASE_IMAGE_ARG
FROM ${BASE_IMAGE_ARG}

ARG NB_PREFIX=/
ARG NB_TYPE=lab
ENV HOME=/home/jovyan
ENV DEBIAN_FRONTEND noninteractive

WORKDIR ${HOME}

COPY clean-layer.sh /usr/bin/clean-layer.sh
COPY bashrc /etc/bash.bashrc
COPY requirements.txt .

RUN chmod a+rwx /usr/bin/clean-layer.sh
RUN chmod a+rwx /etc/bash.bashrc

# runtime support
RUN apt-get -yq update \
    && apt-get install -y --no-install-recommends \
    curl \
    g++ \
    gcc \
    build-essential \
    nano \
    && clean-layer.sh

# node.js
RUN curl -sL "https://deb.nodesource.com/gpgkey/nodesource.gpg.key" | apt-key add - \
    && echo "deb https://deb.nodesource.com/node_14.x focal main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get -yq update \
    && apt-get -yq install --no-install-recommends \
    nodejs \
    && clean-layer.sh

RUN python -m pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade pystan \
    && pip install --no-cache-dir -r requirements.txt

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]