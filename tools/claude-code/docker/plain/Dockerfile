FROM ghcr.io/sfmunoz/jails-base:latest
ARG USER_ID=1002
USER u${USER_ID}
RUN curl -fsSL https://claude.ai/install.sh | bash
USER root
RUN mv /home/u${USER_ID}/.local /home/u${USER_ID}_local && \
  chmod 700 /home/u${USER_ID}_local && \
  ln -s /home/u${USER_ID}_local /home/u${USER_ID}/.local
USER u${USER_ID}
ENV PATH="/home/u${USER_ID}/.local/bin:${PATH}"
WORKDIR /workspace
