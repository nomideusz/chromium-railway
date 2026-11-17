#!/bin/bash
# Entrypoint in front of linuxserver's /init. Railway's Free plan caps a service
# at 0.5 GB, and this desktop (Xvfb, Selkies and the app) is OOM-killed there,
# which Railway counts against the template. On a service that small, serve a
# page that says what's needed instead of starting anything; otherwise hand over
# to s6-overlay's /init, which has to be PID 1 (hence exec).

mem=$(cat /sys/fs/cgroup/memory.max 2>/dev/null)
case "$mem" in ''|max) exec /init "$@" ;; esac
[ "$mem" -ge $((900 * 1024 * 1024)) ] && exec /init "$@"

app=${TITLE:-This desktop}
port=${PORT:-${CUSTOM_PORT:-3000}}
mkdir -p /run/gate
cat > /run/gate/index.html <<HTML
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>$app needs more memory</title><style>body{font:16px/1.5 system-ui,sans-serif;max-width:40rem;margin:3rem auto;padding:0 1rem}</style></head>
<body><h1>$app needs at least 1 GB of memory</h1>
<p>This service is limited to $((mem / 1024 / 1024)) MB, which is Railway's Free plan. A desktop streamed to your browser doesn't fit in that and would be killed for lack of memory, so nothing has been started.</p>
<p>The Trial plan (1 GB) runs it, and Hobby gives it more room. Upgrade, then redeploy this service.</p></body></html>
HTML
cat > /run/gate/nginx.conf <<CONF
worker_processes 1;
pid /run/gate/nginx.pid;
error_log stderr;
events {}
http {
  access_log off;
  server {
    listen $port default_server;
    listen [::]:$port default_server;
    root /run/gate;
    location = /healthcheck { return 200 "ok"; }
    location / { try_files /index.html =404; }
  }
}
CONF
echo "Railway: this service is limited to $((mem / 1024 / 1024)) MB, under the 1 GB $app needs. Serving instructions on :$port instead of starting it."
exec nginx -c /run/gate/nginx.conf -g 'daemon off;'
