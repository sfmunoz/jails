FROM ghcr.io/sfmunoz/jails-base:latest

RUN mkdir -p /home/jails_local && \
  chmod 700 /home/jails_local && \
  chown -R jails:jails /home/jails_local && \
  rm -rf /home/jails/.local && \
  sudo -u jails ln -s ../jails_local /home/jails/.local

USER jails

RUN curl -fsSL https://claude.ai/install.sh | bash

RUN rm -rf /home/jails/.claude* /home/jails/.cache

ENV PATH="/home/jails/.local/bin:${PATH}"

WORKDIR /workspace
