FROM ghcr.io/sfmunoz/jails-base:latest
ARG USER_ID=1002
USER u${USER_ID}
RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="/home/u${USER_ID}/.local/bin:${PATH}"
WORKDIR /workspace
