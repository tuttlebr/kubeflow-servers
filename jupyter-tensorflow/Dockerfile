ARG BUILD_VERSION_ARG
FROM tuttlebr/kubeflow-servers:jupyter-$BUILD_VERSION_ARG

# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
   && rm -f /tmp/requirements.txt
