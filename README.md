# Beeper Desktop on Selkies

Run [Beeper Desktop](https://www.beeper.com/download) v4 in a browser with the [LinuxServer.io Selkies base image](https://github.com/linuxserver/docker-baseimage-selkies). The container uses Debian 13 and a Wayland session. Selkies handles video, audio, clipboard and file transfers; there is no VNC server. The base includes Noto CJK fonts.

This is an unofficial image, not supported by Beeper or LinuxServer.io.

## Quick start

```sh
docker run -d --name beeper-selkies --restart unless-stopped \
  --shm-size=1g \
  -p 127.0.0.1:3001:3001 \
  -v beeper-selkies-config:/config \
  etnperlong/beeper:latest
```

Open **https://localhost:3001/**. Selkies needs a secure browser context for video decoding and clipboard APIs. The container generates a self-signed certificate on first start. Use `--shm-size=1g` for the compositor and audio. No privileged mode or FUSE device is required.

You can sign in with email or Google. Google sign-in opens Firefox inside the remote desktop so Beeper can receive the callback on the container’s loopback interface.

## Building locally

Run `docker build -t etnperlong/beeper:latest .` and use the same `docker run` command above. To build a specific v4 release, pass `--build-arg BEEPER_VERSION=4.3.340` with the version you want.

GitHub Actions builds `linux/amd64` and `linux/arm64` from the official Beeper stable release on pushes to `main`, on demand, and weekly. It publishes `latest` and `beeper-<version>` tags to [Docker Hub](https://hub.docker.com/r/etnperlong/beeper). Configure the `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` repository secrets with a Docker Hub account and a token with write access before running the workflow.

## Configuration

| Setting | Purpose |
| --- | --- |
| `/config` | Persistent volume. Beeper's profile is in `/config/.config/BeeperTexts`; the launcher writes `/config/beeper.log` for the current launch. |
| `PUID` / `PGID` | Session user and group, both `1000` by default. Match host ownership if you use a bind mount. |
| `PASSWORD` / `CUSTOM_USER` | Optional Selkies HTTP Basic Auth. The default username is `abc`; no password means no authentication. |
| `PIXELFLUX_WAYLAND=false` | Use the base's X11/Openbox session instead of Wayland/labwc. |
| `RESTART_APP=false` | Leave Beeper closed when you quit it. The default restarts it. |
| `SELKIES_MICROPHONE_ENABLED=true` | Opt in to browser microphone forwarding. |

See the [Selkies configuration reference](https://docs.linuxserver.io/selkies/user-guide/configuration/) for other settings.

> [!WARNING]
> Anyone who can open an unauthenticated session can use the signed-in Beeper account. Keep the port bound to loopback, or put it behind an authenticated HTTPS reverse proxy with WebSocket support. The proxy can reach Selkies over port `3000` on a private container network; do not publish that HTTP port publicly. Sharing links, `sudo`, and the inner Docker daemon are off. The Electron sandbox is disabled; do not give this container host devices, a Docker socket, or privileges it does not need.

## Moving from the jlesage image

Switch to `etnperlong/beeper:latest`, start with a **new** `/config` volume, and sign in again. Keep the old volume untouched until the new session works; do not mount it into both containers. The old image used ports `5800`/`5900` and `USER_ID`/`GROUP_ID`. Use HTTPS on `3001` and `PUID`/`PGID` here. There is no automatic profile or credential importer.
