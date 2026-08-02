FROM linuxserver/chromium:latest

# ponytail: one custom-init script adds an unauthenticated /healthcheck
# location for Railway's healthcheck prober; everything else is stock.
COPY root/ /
RUN chmod +x /custom-cont-init.d/20-healthcheck
