ARG SELKIES_TAG=debiantrixie
FROM ghcr.io/linuxserver/baseimage-selkies:${SELKIES_TAG}

ARG BEEPER_VERSION=4.3.340

RUN set -eu; \
    case "$(dpkg --print-architecture)" in \
        amd64) beeper_arch=x86_64 ;; \
        arm64) beeper_arch=arm64 ;; \
        *) echo 'Beeper supports only amd64 and arm64' >&2; exit 1 ;; \
    esac; \
    apt-get update; \
    apt-get install -y --no-install-recommends firefox-esr libsecret-1-0; \
    rm -rf /var/lib/apt/lists/*; \
    workdir=$(mktemp -d); \
    cd "$workdir"; \
    curl -fsSL -o beeper.AppImage \
        "https://beeper-desktop.download.beeper.com/builds/Beeper-${BEEPER_VERSION}-${beeper_arch}.AppImage"; \
    chmod +x beeper.AppImage; \
    ./beeper.AppImage --appimage-extract > /dev/null; \
    mv squashfs-root /opt/beeper; \
    cd /; \
    rm -rf "$workdir"; \
    libs=$(LD_LIBRARY_PATH=/opt/beeper/usr/lib ldd /opt/beeper/beepertexts); \
    if printf '%s\n' "$libs" | grep 'not found'; then exit 1; fi

COPY --chmod=0755 rootfs/startapp.sh /startapp.sh
COPY --chmod=0755 rootfs/autostart /defaults/autostart
COPY --chmod=0755 rootfs/autostart /defaults/autostart_wayland
COPY LICENSE THIRD_PARTY_NOTICES.md /usr/share/doc/docker-beeper/

ENV TITLE=Beeper \
    PUID=1000 \
    PGID=1000 \
    PIXELFLUX_WAYLAND=true \
    RESTART_APP=true \
    START_DOCKER=false \
    DISABLE_SUDO=true \
    NO_GAMEPAD=true \
    NO_STEAM=true \
    NO_WEBCAM=true \
    SELKIES_ENABLE_SHARING=false

LABEL org.opencontainers.image.title="Beeper Desktop (Selkies)" \
      org.opencontainers.image.description="Unofficial Beeper Desktop container with the Selkies web client" \
      org.opencontainers.image.version="${BEEPER_VERSION}"
