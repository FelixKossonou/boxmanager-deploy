#!/bin/sh
/pb/pocketbase serve --http=0.0.0.0:${PORT:-8090} &
PB_PID=$!
sleep 6
/pb/pocketbase admin create admin@boxmanager.local "BoxManager2024!" 2>/dev/null || true
sleep 2
TOKEN=$(curl -s -X POST "http://127.0.0.1:${PORT:-8090}/api/admins/auth-with-password" \
  -H "Content-Type: application/json" \
  -d '{"identity":"admin@boxmanager.local","password":"BoxManager2024!"}' \
  | grep -oE '"token":"[^"]+"' | cut -d'"' -f4)
if [ -n "$TOKEN" ]; then
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $TOKEN" \
    "http://127.0.0.1:${PORT:-8090}/api/collections/boxes")
  if [ "$HTTP_CODE" = "404" ]; then
    curl -s -X POST "http://127.0.0.1:${PORT:-8090}/api/collections" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $TOKEN" \
      -d '{"name":"boxes","type":"base","schema":[{"name":"deviceId","type":"text"},{"name":"label","type":"text"},{"name":"model","type":"text"},{"name":"brand","type":"text"},{"name":"macAddress","type":"text"},{"name":"blocked","type":"bool"},{"name":"comment","type":"text"},{"name":"online","type":"bool"},{"name":"lastSeen","type":"text"},{"name":"paused","type":"bool"},{"name":"reboot","type":"bool"},{"name":"lock_message","type":"text"}],"listRule":"","viewRule":"","createRule":"","updateRule":"","deleteRule":""}'
  fi
fi
wait $PB_PID
