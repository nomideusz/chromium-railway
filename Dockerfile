FROM linuxserver/chromium:075b0b99-ls64

# Debian's security update reaches apt before LinuxServer's weekly rebuild does, so take it here.
RUN apt-get update && apt-get install -y --only-upgrade chromium && rm -rf /var/lib/apt/lists/*

# MAX_RES capped the Xvfb screen on older X11 bases; this Wayland base ignores it.
# 15-small-plan-resolution locks the desktop at 1920x1080 instead: on every plan, since
# Railway's 61 MiB /dev/shm can't hold a 4K screen's buffers (black page, 2 GB too).
ENV MAX_RES=3840x2160 RESOLUTION_LOCK_BELOW_MIB=always

# ponytail: one custom-init script adds an unauthenticated /healthcheck
# location for Railway's healthcheck prober; everything else is stock.
COPY root/ /
RUN chmod +x /railway-gate.sh /custom-cont-init.d/15-small-plan-resolution /custom-cont-init.d/20-healthcheck /custom-services.d/drop-file-cache /usr/local/bin/drop-file-cache

# Free plan (0.5 GB): serve a "needs 1 GB" page instead of starting the desktop (see railway-gate.sh).
# There the browser opens but every real page is OOM-killed ("Error code 9") while the deploy looks healthy.
ENTRYPOINT ["/railway-gate.sh"]
