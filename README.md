# Beeper Desktop on Selkies

[![Docker image: etnperlong/beeper](https://img.shields.io/badge/Docker-etnperlong%2Fbeeper-2496ED?logo=docker&logoColor=white&style=for-the-badge)](#quick-start)
[![Platforms: amd64 and arm64](https://img.shields.io/badge/Platforms-amd64%20%2F%20arm64-555?style=for-the-badge)](.github/workflows/build.yml)
[![Repository code: MIT](https://img.shields.io/badge/Code-MIT-2EA44F?style=for-the-badge)](LICENSE)

Run [Beeper Desktop](https://www.beeper.com/download) v4 in your browser. This unofficial image uses [LinuxServer.io's Selkies base](https://github.com/linuxserver/docker-baseimage-selkies) on Debian 13 with Wayland.

## Quick start

Build from the repository root with `docker build -t etnperlong/beeper:latest .`. Once the image is published to [Docker Hub](https://hub.docker.com/r/etnperlong/beeper), you can skip the build. For Podman, replace `docker` with `podman`.

```sh
docker run -d --name beeper --restart unless-stopped \
  --shm-size=1g \
  -p 127.0.0.1:3001:3001 \
  -v beeper-config:/config \
  etnperlong/beeper:latest
```

Open **<https://localhost:3001/>**. Expect a certificate warning on first use: the container generates a self-signed certificate. Google sign-in opens Firefox inside the remote desktop; email sign-in stays in Beeper.

<details>
<summary>Deploy with Docker Compose instead</summary>

Save as `compose.yaml` and run `docker compose up -d`.

```yaml
services:
  beeper:
    image: etnperlong/beeper:latest
    restart: unless-stopped
    shm_size: 1g
    ports:
      - "127.0.0.1:3001:3001"
    volumes:
      - beeper-config:/config
volumes:
  beeper-config:
```

</details>

## Network access

> [!IMPORTANT]
> The web desktop has no authentication by default. Anyone who can reach it can control the signed-in Beeper session. Prefer localhost, a trusted LAN, or a private VPN.

| Access | Setup |
| --- | --- |
| Same host | Keep the example's loopback binding on HTTPS port `3001`. |
| Trusted LAN or VPN | Bind `3001` to the host's private IP, restrict access with a firewall, and set `CUSTOM_USER` and `PASSWORD` for Basic Auth over HTTPS. |
| Public internet, only if needed | Remove the port mapping. On a private container network, [proxy to `http://beeper:3000`](https://docs.linuxserver.io/selkies/user-guide/reverse-proxy/) using the service/container name. Terminate TLS with a trusted certificate and enforce authentication with MFA on both HTTP requests and WebSocket upgrades. Do not rely on built-in Basic Auth alone. |

Beeper runs without the Electron sandbox. Do not use `--privileged` or mount the host's Docker socket.

## Data and logs

| Item | What to know |
| --- | --- |
| `/config` | Stores your profile and session. Keep the volume private and reuse it across updates. |
| `PUID` / `PGID` | Default: `1000` / `1000`. Match the bind-mount directory owner if you use a host path. |
| Logs | Use `docker logs beeper` for container startup and `docker exec beeper cat /config/beeper.log` for Beeper output. With Compose, use `docker compose logs beeper` and `docker compose exec beeper cat /config/beeper.log`. |

See the [Selkies configuration reference](https://docs.linuxserver.io/selkies/user-guide/configuration/) for more settings. The [MIT license](LICENSE) covers this repository's code; [bundled components](THIRD_PARTY_NOTICES.md) retain their upstream terms.
