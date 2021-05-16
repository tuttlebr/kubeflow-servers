ARG BUILD_VERSION_ARG
FROM tuttlebr/kubeflow-servers/base:$BUILD_VERSION_ARG

USER root

# args - software versions
ARG CODESERVER_VERSION=3.10.0
ARG CODESERVER_PYTHON_VERSION="2021.3.658691958"
ARG CONDA_VERSION="4.9.2"
ARG MINIFORGE_ARCH="x86_64"
ARG MINIFORGE_SHA256="91d5aa5f732b5e02002a371196a2607f839bab166970ea06e6ecc602cb446848"
ARG MINIFORGE_VERSION="${CONDA_VERSION}-7"
ARG PIP_VERSION="21.0.1"
ARG PYTHON_VERSION="3.8.8"

# setup environment for conda
ENV CONDA_DIR /opt/conda
ENV PATH "${CONDA_DIR}/bin:${PATH}"
RUN mkdir -p ${CONDA_DIR} \
    && chown -R ${NB_USER}:users ${CONDA_DIR}

# install - code-server
RUN curl -sL "https://github.com/cdr/code-server/releases/download/v${CODESERVER_VERSION}/code-server_${CODESERVER_VERSION}_amd64.deb" -o /tmp/code-server.deb \
    && dpkg -i /tmp/code-server.deb \
    && rm -f /tmp/code-server.deb

# s6 - copy scripts
COPY --chown=jovyan:users s6/ /etc

# s6 - 01-copy-tmp-home
RUN mkdir -p /tmp_home \
    && cp -r ${HOME} /tmp_home \
    && chown -R ${NB_USER}:users /tmp_home

USER $NB_UID

# install - conda, pip, python
RUN curl -sL "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-${MINIFORGE_ARCH}.sh" -o /tmp/Miniforge3.sh \
    && echo "${MINIFORGE_SHA256} /tmp/Miniforge3.sh" | sha256sum --check \
    && /bin/bash /tmp/Miniforge3.sh -b -f -p ${CONDA_DIR} \
    && rm /tmp/Miniforge3.sh \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && echo "conda ${CONDA_VERSION}" >> ${CONDA_DIR}/conda-meta/pinned \
    && echo "python ${PYTHON_VERSION}" >> ${CONDA_DIR}/conda-meta/pinned \
    && conda install -y -q \
    python=${PYTHON_VERSION} \
    conda=${CONDA_VERSION} \
    pip=${PIP_VERSION} \
    && conda update -y -q --all \
    && conda clean -a -f -y \
    && chown -R ${NB_USER}:users ${CONDA_DIR} \
    && chown -R ${NB_USER}:users ${HOME}

# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
    && rm -f /tmp/requirements.txt \
    && chown -R ${NB_USER}:users ${CONDA_DIR} \
    && chown -R ${NB_USER}:users ${HOME}

# install - codeserver extensions
RUN code-server --install-extension "ms-python.python@${CODESERVER_PYTHON_VERSION}" \
    code-server --install-extension ikuyadeu.r-pack \
    code-server --install-extension ms-azuretools.vscode-docker \
    code-server --install-extension ms-mssql.mssql \
    code-server --install-extension robbowen.synthwave-vscode

# s6 - copy scripts
COPY --chown=jovyan:users s6/ /etc

# s6 - 01-copy-tmp-home
USER root
RUN mkdir -p /tmp_home \
    && cp -r ${HOME} /tmp_home \
    && chown -R ${NB_USER}:users /tmp_home

USER ${NB_UID}

EXPOSE 8888

ENTRYPOINT ["/init"]