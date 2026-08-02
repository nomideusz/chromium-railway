# Deploy and Host Chromium (Cloud Browser) on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/chromium?utm_medium=integration&utm_source=button&utm_campaign=chromium)

This template runs a full desktop [Chromium](https://www.chromium.org/) browser in the cloud, streamed to any device through the [linuxserver.io](https://docs.linuxserver.io/images/docker-chromium/) Selkies web interface. Open your Railway domain, log in, and you're inside a real browser running on the server — bookmarks, extensions, downloads, and sessions persist between visits.

## About Hosting Chromium

The service streams a GPU-less desktop Chromium over WebSockets with the linuxserver.io Selkies stack. Access is gated by HTTP basic auth (`CUSTOM_USER` / generated `PASSWORD`), and the browser profile persists on a volume at `/config`. The `--disable-dev-shm-usage` flag is pre-set so Chromium runs happily within Railway's container shared memory.

## Common Use Cases

- Disposable browsing environment isolated from your real machine and network — open sketchy links without them touching your device
- Persistent browser session with a stable egress IP: stay logged in to sites, resume long downloads, keep tabs running 24/7
- Quick cross-check of geo-dependent or region-blocked content from a datacenter vantage point
- Kiosk-style shared browser for a team (one URL, one login, same session state)

## Dependencies for Chromium Hosting

- None — single service, no database

### Deployment Dependencies

- [linuxserver.io Chromium image docs](https://docs.linuxserver.io/images/docker-chromium/)
- [Selkies project](https://github.com/selkies-project)

### Implementation Details

**First use:** open your Railway domain, log in with `CUSTOM_USER` and the generated `PASSWORD` (service Variables tab), and the desktop appears. On touch devices, use the sidebar for keyboard and gestures.

Notes and limits:

- Keep the login strong: an open cloud browser is a proxy for whoever finds it. The password gate is the whole security model — don't remove it.
- Rendering is CPU-based (no GPU on Railway). Fine for browsing and light video; not for WebGL-heavy work.
- Chromium is memory-hungry: give the service 1–2 GB. Heavy tab hoarding needs more.
- Traffic egresses from Railway's IP range — sites that block datacenter IPs (some streaming services) may object.
- Abuse note: this is a browser, not an anonymizer. Use it within Railway's terms of service and the laws that apply to you.

## Why Deploy Chromium on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Chromium on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
