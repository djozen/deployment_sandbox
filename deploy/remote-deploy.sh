#!/usr/bin/env bash
set -euo pipefail
cd "$DEPLOY_PATH"

# Garder la version actuelle pour pouvoir revenir en arrière
if [ -f .env ]; then cp .env .env.previous; fi

cat > .env <<EOF
REGISTRY_IMAGE=${REGISTRY_IMAGE}
IMAGE_TAG=${IMAGE_TAG}
APP_DOMAIN=${APP_DOMAIN}
EOF

docker compose pull
docker compose run --rm -T php php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration
docker compose up -d --remove-orphans
docker image prune -f
docker compose ps