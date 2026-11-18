# Certificats racine d'entreprise

Les fichiers `*.crt` (PEM) de ce dossier sont ajoutés au magasin de confiance des images PHP
(`update-ca-certificates`). Ils sont nécessaires derrière un proxy qui inspecte le TLS
(Netskope) : sans eux, Composer, PECL, etc. échouent avec « self-signed certificate in certificate chain ».

Exporter une racine depuis Windows (PowerShell en mode restreint : utiliser `certutil`) :

    certutil -split -store Root          # écrit les certificats (DER) dans le dossier courant
    certutil -encode <fichier>.crt netskope-root.crt   # conversion en PEM

Après modification : `docker compose -f docker-compose.dev.yml build php-fpm php-cli composer`.
