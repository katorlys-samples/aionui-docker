FROM debian:trixie-slim

ARG AIONUI_VERSION=latest
ARG TARGETARCH

ENV AIONUI_HOST=0.0.0.0 \
    AIONUI_PORT=25808 \
    AIONUI_ALLOW_REMOTE=1 \
    AIONUI_OPEN_BROWSER=0 \
    AIONUI_DATA_DIR=/data \
    AIONUI_LOG_DIR=/logs

RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    tar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN case "${TARGETARCH:-amd64}" in \
        amd64) AIONUI_ARCH=x86_64 ;; \
        arm64) AIONUI_ARCH=arm64 ;; \
        *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    if [ "${AIONUI_VERSION}" = "latest" ]; then \
        AIONUI_VERSION="$(curl -fsSL https://api.github.com/repos/iOfficeAI/AionUi/releases/latest | grep '"tag_name"' | head -1 | sed 's/.*"v\([^"]*\)".*/\1/')"; \
    fi; \
    TARBALL="aionui-web-${AIONUI_VERSION}-linux-${AIONUI_ARCH}.tar.gz"; \
    BASE_URL="https://github.com/iOfficeAI/AionUi/releases/download/v${AIONUI_VERSION}"; \
    curl -fSL -o "/tmp/${TARBALL}" "${BASE_URL}/${TARBALL}"; \
    curl -fSL -o "/tmp/${TARBALL}.sha256" "${BASE_URL}/${TARBALL}.sha256"; \
    cd /tmp; \
    sha256sum -c "${TARBALL}.sha256"; \
    mkdir -p /opt; \
    tar -xzf "/tmp/${TARBALL}" -C /opt; \
    chmod +x /opt/aionui-web/aionui-web; \
    rm -f "/tmp/${TARBALL}" "/tmp/${TARBALL}.sha256"; \
    mkdir -p /data /logs

WORKDIR /opt/aionui-web

EXPOSE 25808

VOLUME ["/data", "/logs"]

CMD ["/opt/aionui-web/aionui-web", "start", "--remote", "--no-open"]