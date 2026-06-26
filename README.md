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

## Hosting Additional Files or Containers on xrpl17.lightningcomms.net

The subdomain xrpl17.lightningcomms.net is currently proxied to the same backend server (98.183.227.178) as the root.

### Option 1: Move to Cloudflare (Static Files via Pages or R2 + Worker)
1. Push your local files to this repo (e.g., add to a xrpl17-static/ folder or root for simple site).
2. In Cloudflare dashboard for lightningcomms.net:
   - Pages > Create project > Connect to Git > select this repo.
   - Set build settings for static (or framework if applicable).
   - Add custom domain: xrpl17.lightningcomms.net
3. DNS will be handled by CF (keep the A record proxied).
4. For dynamic or containers: Not directly; use a backend server and CF Tunnel or direct.

For R2:
- Upload files to an R2 bucket.
- Create a Worker to serve from R2.
- Add custom domain xrpl17.lightningcomms.net to the Worker.

### Option 2: On the Backend Server (Current Host)
- Transfer local files to the server:
  From your local Windows: scp -r C:\path\to\local\files user@98.183.227.178:/var/www/xrpl17/
- On the server, configure nginx or the web server to serve for the subdomain xrpl17.lightningcomms.net (server block with root to the files).
- For containers: Add to docker-compose or run separate, expose on different port, configure reverse proxy.

### Option 3: GitHub Hosted
- Push files to this or a separate repo.
- Use GitHub Pages for the repo, add custom domain xrpl17.lightningcomms.net (CNAME to your-username.github.io).
- Since CF is in front, you can proxy or use Pages + CF.

The mumble server is separate on mumble subdomain. Deploy it on the host as before.

To move a specific file/container, tell me the path or name, and I'll help generate the exact commands or update the repo.
