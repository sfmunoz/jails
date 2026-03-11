FROM ghcr.io/sfmunoz/jails-base:latest

USER jails

RUN curl -fsSL https://claude.ai/install.sh | bash

USER root

RUN mv /home/jails/.local /home/jails_local && \
  chmod 700 /home/jails_local && \
  ln -s /home/jails_local /home/jails/.local

USER jails

ENV PATH="/home/jails/.local/bin:${PATH}"

WORKDIR /workspace
