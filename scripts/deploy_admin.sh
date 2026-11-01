#!/usr/bin/env bash
# Publishes admin/index.html to PythonAnywhere as https://<user>.pythonanywhere.com/
# Needs an API token (PythonAnywhere → Account → API token) in $iraqchatapp_PA_TOKEN.
#   scripts/deploy_admin.sh            # user iraqchatapp
#   PA_USER=other scripts/deploy_admin.sh
set -euo pipefail
cd "$(dirname "$0")/.."

PA_USER="${PA_USER:-iraqchatapp}"
TOKEN_VAR="${PA_USER}_PA_TOKEN"
TOKEN="${!TOKEN_VAR:-}"
[ -n "$TOKEN" ] || { echo "Set \$$TOKEN_VAR to the PythonAnywhere API token"; exit 1; }
HOST="${PA_HOST:-www.pythonanywhere.com}"
API="https://$HOST/api/v0/user/$PA_USER"
DOMAIN="$PA_USER.pythonanywhere.com"
WSGI="/var/www/${DOMAIN//./_}_wsgi.py"
auth=(-H "Authorization: Token $TOKEN")

upload() { # local remote
  curl -sS --fail-with-body "${auth[@]}" -F "content=@$1" "$API/files/path$2" > /dev/null
  echo "uploaded $2"
}

# 1. The page.
upload admin/index.html "/home/$PA_USER/admin/index.html"

# 2. Web app (created once).
code=$(curl -s -o /dev/null -w '%{http_code}' "${auth[@]}" "$API/webapps/$DOMAIN/")
if [ "$code" = 404 ]; then
  curl -sS --fail-with-body "${auth[@]}" -X POST "$API/webapps/" \
    -d "domain_name=$DOMAIN" -d "python_version=python310" > /dev/null
  echo "created web app $DOMAIN"
fi

# 3. A tiny WSGI app that serves the dashboard for every path.
tmp=$(mktemp)
cat > "$tmp" <<PY
PAGE = '/home/$PA_USER/admin/index.html'

def application(environ, start_response):
    with open(PAGE, 'rb') as f:
        body = f.read()
    start_response('200 OK', [('Content-Type', 'text/html; charset=utf-8'),
                              ('Cache-Control', 'no-cache')])
    return [body]
PY
upload "$tmp" "$WSGI"
rm -f "$tmp"

# 4. HTTPS only, then reload.
curl -sS --fail-with-body "${auth[@]}" -X PATCH "$API/webapps/$DOMAIN/" -d "force_https=true" > /dev/null || true
curl -sS --fail-with-body "${auth[@]}" -X POST "$API/webapps/$DOMAIN/reload/" > /dev/null
echo "live: https://$DOMAIN/"
