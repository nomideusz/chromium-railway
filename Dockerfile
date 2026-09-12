FROM linuxserver/chromium:latest

# Upstream starts Xvfb with a 15360x8640 screen, which pins ~600 MB for the
# framebuffer alone and OOM-kills the desktop on Railway's 512 MB Trial plan.
# 4K is plenty; Selkies still resizes the desktop to the browser window.
ENV MAX_RES=3840x2160

# ponytail: one custom-init script adds an unauthenticated /healthcheck
# location for Railway's healthcheck prober; everything else is stock.
COPY root/ /
RUN chmod +x /custom-cont-init.d/20-healthcheck
