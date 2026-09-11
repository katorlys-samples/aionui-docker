FROM oven/bun:1-debian AS build

ARG AIONUI_VERSION=latest
ARG TARGETARCH

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl git nodejs; \
    rm -rf /var/lib/apt/lists/*; \
    case "${TARGETARCH:-amd64}" in \
        amd64) AIONUI_ARCH=x64 ;; \
        arm64) AIONUI_ARCH=arm64 ;; \
        *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    if [ "${AIONUI_VERSION}" = "latest" ]; then \
        AIONUI_VERSION="$(curl -fsSL https://api.github.com/repos/iOfficeAI/AionUi/releases/latest | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p' | head -1)"; \
    fi; \
    test -n "${AIONUI_VERSION}"; \
    git clone --depth 1 --branch "v${AIONUI_VERSION}" https://github.com/iOfficeAI/AionUi.git /src/aionui; \
    cd /src/aionui; \
    bun install --frozen-lockfile; \
    bunx electron-vite build --config packages/desktop/electron.vite.config.ts; \
    PACK_PLATFORM=linux PACK_ARCH="${AIONUI_ARCH}" node scripts/pack-web-cli.js; \
    mkdir -p /opt; \
    tarball="$(find dist-web-cli -maxdepth 1 -type f -name 'aionui-web-*.tar.gz' -print -quit)"; \
    test -n "${tarball}"; \
    tar -xzf "${tarball}" -C /opt; \
    test -x /opt/aionui-web/aionui-web

FROM debian:trixie-slim

ENV AIONUI_HOST=0.0.0.0 \
    AIONUI_PORT=25808 \
    AIONUI_ALLOW_REMOTE=1 \
    AIONUI_OPEN_BROWSER=0 \
    AIONUI_DATA_DIR=/data \
    AIONUI_LOG_DIR=/logs

RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libgcc-s1 \
    libstdc++6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /data /logs

COPY --from=build /opt/aionui-web /opt/aionui-web

WORKDIR /opt/aionui-web

EXPOSE 25808

VOLUME ["/data", "/logs"]

CMD ["/opt/aionui-web/aionui-web", "start", "--remote", "--no-open"]