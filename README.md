# Mumble Server (Murmur) for lightningcomms.net

This repository contains the configuration to run a self-hosted [Mumble](https://www.mumble.info/) voice server (Murmur) using Docker.

## Quick Start

### 1. Clone and run
```bash
git clone https://github.com/RaginCajunSteve/mumble-server.git
cd mumble-server
docker compose up -d
```

The server will be available on UDP/TCP port **64738**.

### 2. Connect with Mumble client
- Download client from https://www.mumble.info/
- Server: `mumble.lightningcomms.net:64738` (or your server's IP/hostname)
- Default superuser: `SuperUser` / password from `MUMBLE_SUPERUSER_PASSWORD` in compose (change it!)

### 3. Configure
- Edit `config/murmur.ini` for server name, bandwidth, welcome message, etc.
- Restart: `docker compose restart`

## Cloudflare Configuration

### DNS
Add an **A** (or AAAA) record in Cloudflare for your domain:
- Name: `mumble`
- Content: Your server's public IP
- Proxy status: **DNS only** (grey cloud) — required for UDP voice traffic.

Example: `mumble.lightningcomms.net` → `your.vps.ip`

### Recommended: Use Cloudflare Tunnel (zero-trust, no open ports)
If you want to avoid opening ports on your host:

1. Install `cloudflared` on the server hosting Docker.
2. Create a Tunnel in Cloudflare dashboard (or via CLI).
3. Configure ingress for UDP/TCP:

```yaml
# cloudflared config.yml
tunnel: your-tunnel-id
credentials-file: /path/to/credentials.json

ingress:
  - hostname: mumble.lightningcomms.net
    service: udp://localhost:64738
  - service: http_status:404
```

Run: `cloudflared tunnel run`

Note: Full low-latency UDP voice works best with direct exposure or Spectrum. Tunnel adds a hop.

### Spectrum (L4 proxy - paid)
If you have Cloudflare Spectrum (available on certain paid plans):
- Proxy TCP + UDP on port 64738 through Cloudflare.
- Hides your origin IP and adds DDoS protection.

## Security Notes
- Change the superuser password immediately.
- Consider setting a `serverpassword` in `murmur.ini` for access control.
- Keep the container updated: `docker compose pull && docker compose up -d`
- For production, mount persistent volumes properly and back up `data/murmur.sqlite`.

## Updating
```bash
docker compose pull
docker compose up -d
```

## License
Mumble is open source (BSD 3-Clause). This config repo is MIT.
