# Beeper Desktop on Selkies

Run [Beeper Desktop](https://www.beeper.com/download) v4 in your browser on a Linux host. This unofficial image uses [LinuxServer.io's Selkies base](https://github.com/linuxserver/docker-baseimage-selkies) (Debian 13, Wayland) and targets `linux/amd64` and `linux/arm64`.

## Deploy

> [!IMPORTANT]
> Keep Beeper on localhost, a trusted LAN, or a private VPN. The web desktop has no authentication by default. Anyone who can open it can control the signed-in Beeper session.

Use `etnperlong/beeper:latest` from [Docker Hub](https://hub.docker.com/r/etnperlong/beeper) when published, or build it locally from this repository with `docker build -t etnperlong/beeper:latest .`. The same commands work with Podman by replacing `docker` with `podman`.

```sh
docker run -d --name beeper --restart unless-stopped \
  --shm-size=1g \
  -p 127.0.0.1:3001:3001 \
  -v beeper-config:/config \
  etnperlong/beeper:latest
```

Open <https://localhost:3001/>. The container generates a self-signed certificate on first start. Sign in with email or Google; Google opens Firefox inside the remote desktop to receive the sign-in callback.

### Network access

- **Trusted LAN or VPN:** bind HTTPS port `3001` to the host's private IP instead of `127.0.0.1`, restrict access with a firewall, and set `CUSTOM_USER` and `PASSWORD` for Basic Auth over HTTPS.
- **Public access, only if needed:** put Beeper behind a [reverse proxy](https://docs.linuxserver.io/selkies/user-guide/reverse-proxy/) with a browser-trusted TLS certificate and authentication such as Authelia or Authentik with MFA. Protect both HTTP requests and WebSocket upgrades. On a private container network, proxy to `http://beeper:3000` (using the container or service name) and omit the `-p` mapping. Do not publish either container port to the internet or rely on built-in Basic Auth alone.

> [!WARNING]
> Beeper runs without the Electron sandbox. Do not use `--privileged` or mount the host's Docker socket.

### Data and logs

- `/config` stores the Beeper profile and session data. Keep the volume private and reuse it when updating the container.
- For a bind mount, set `PUID` and `PGID` to match the host directory owner (both default to `1000`).
- Check startup with `docker logs beeper` and application output with `docker exec beeper cat /config/beeper.log`.

See the [Selkies configuration reference](https://docs.linuxserver.io/selkies/user-guide/configuration/) for other settings. Repository code is [MIT-licensed](LICENSE); bundled components retain [their upstream terms](THIRD_PARTY_NOTICES.md).
