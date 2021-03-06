ARG BASE_IMAGE_ARG
FROM ${BASE_IMAGE_ARG}

USER root

# set version for s6 overlay
ARG OVERLAY_VERSION="v2.2.0.1"
ARG OVERLAY_ARCH="amd64"

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer /tmp/
RUN chmod +x /tmp/s6-overlay-${OVERLAY_ARCH}-installer && /tmp/s6-overlay-${OVERLAY_ARCH}-installer / && rm /tmp/s6-overlay-${OVERLAY_ARCH}-installer

RUN echo "**** install node repo ****" && \
    curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node_14.x focal main' \
    > /etc/apt/sources.list.d/nodesource.list && \
    curl -s https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb https://dl.yarnpkg.com/debian/ stable main' \
    > /etc/apt/sources.list.d/yarn.list && \
    echo "**** install build dependencies ****" && \
    apt-get update && \
    apt-get install -y \
    build-essential \
    libx11-dev \
    libxkbfile-dev \
    libsecret-1-dev \
    pkg-config && \
    echo "**** install runtime dependencies ****" && \
    apt-get install -y \
    jq \
    nano \
    net-tools \
    nodejs \
    yarn \
    python3-pip \
    apache2 && \
    echo "**** install code-server ****" && \
    if [ -z ${CODE_RELEASE+x} ]; then \
    CODE_RELEASE=$(curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
    fi && \
    CODE_VERSION=$(echo "$CODE_RELEASE" | awk '{print substr($1,2); }') && \
    yarn config set network-timeout 600000 -g && \
    yarn --production --verbose --frozen-lockfile global add code-server@"$CODE_VERSION" && \
    yarn cache clean && \
    echo "**** clean up ****" && \
    apt-get purge --auto-remove -y \
    build-essential \
    libx11-dev \
    libxkbfile-dev \
    libsecret-1-dev \
    pkg-config && \
    apt-get clean && \
    rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

RUN mkdir -p /home/jovyan/.local/share/code-server
# install - codeserver extensions
RUN code-server --install-extension ms-python.python \
    code-server --install-extension ikuyadeu.r-pack \
    code-server --install-extension ms-azuretools.vscode-docker \
    code-server --install-extension ms-mssql.mssql \
    code-server --install-extension robbowen.synthwave-vscode

COPY requirements.txt .
RUN python3 -m pip install -r \
    requirements.txt --quiet --no-cache-dir \
    && rm -f requirements.txt

COPY root/ /

COPY code-server-proxy.conf /etc/apache2/sites-enabled/code-server-proxy.conf

RUN echo 'Listen 8888' > /etc/apache2/ports.conf

RUN a2enmod proxy proxy_ajp proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html proxy_wstunnel

EXPOSE 8888

ENTRYPOINT ["/init"]