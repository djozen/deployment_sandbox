#!/bin/sh
# Copie en boucle le projet Windows (/source) vers le volume Docker (/var/www/html),
# stocké sur le disque Linux de WSL2 : les accès fichiers de PHP y sont rapides.
set -u

SRC=/source
DST=/var/www/html
INTERVAL="${SYNC_INTERVAL:-2}"

# 33 = www-data dans les images php (Debian)
chown 33:33 "$DST"

sync_once() {
    rsync -rlt --delete --chown=33:33 --chmod=D775,F664 \
        --exclude-from=/etc/sync-excludes.txt "$SRC/" "$DST/"
    code=$?
    # 24 = fichier disparu pendant la copie, sans gravité
    if [ "$code" -ne 0 ] && [ "$code" -ne 24 ]; then
        echo "rsync a échoué (code $code)" >&2
        return 1
    fi
}

until sync_once; do
    sleep "$INTERVAL"
done
touch "$DST/.docker-synced"
echo "Synchronisation initiale terminée"

while true; do
    sleep "$INTERVAL"
    sync_once
done
