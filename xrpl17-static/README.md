# XRPL17 Static Hosting

This folder is for content served at xrpl17.lightningcomms.net via Cloudflare Pages.

## How to push your local files

From your local machine (in the repo dir after clone or pull):

```bash
# Add your files here or copy to xrpl17-static/
cp -r /path/to/your/local/files/* xrpl17-static/
git add xrpl17-static/
git commit -m "Add local files for xrpl17"
git push
```

## Deploy purely in Cloudflare

1. Go to Cloudflare Dashboard > Pages > Create a project > Connect to Git > select this repo (mumble-server).
2. Project name: e.g. xrpl17-lightningcomms (or use existing if repurposing).
3. Build settings: 
   - Framework: None (static)
   - Build command: (leave empty or echo)
   - Output directory: xrpl17-static
4. Save and Deploy.
5. Add custom domain: xrpl17.lightningcomms.net
   - CF will verify (DNS is already set, keep proxied).
6. Done - files served purely from CF at the subdomain.

Note: The mumble server is separate on mumble subdomain. This is for static files/containers (if you have a static site for XRPL or other).

For dynamic containers, run on backend and use subpaths or separate routing.
