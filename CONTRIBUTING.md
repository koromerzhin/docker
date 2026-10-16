# Contributing

## Workflow

1. Prérequis : `docker`, `task` (`npm install -g` non requis, voir [Task](https://taskfile.dev)), `jq`, `node 24` (`.nvmrc`).
2. Cloner avec submodules : `git clone --recurse-submodules git@github.com:koromerzhin/docker.git`.
3. Copier `.env.example` vers `.env` si besoin de surcharger `VERSIONS`, `PLATFORMS`, etc.
4. Générer + builder en local : `task exec VERSIONS=8.4` (ou `npm run docker:build:php`).
5. Tester : `task test:sample` (ou `npm run test:images`).
6. Vérifier la duplication : `npm run lint:duplication` (seuil jscpd : 5 %).

## Règles

- Template Docker unique : `images/php/Dockerfile` (placeholders `VERSIONIMAGE`, `PHPEXTENSIONS`, `PHPLISTEXTENSION`, `PKGINSTALL`, `SYMFONYCLI`, `WORDPRESSPHAR` + `--build-arg SERVER=apache|fpm`). Ne pas recréer de templates par serveur.
- Versions supportées par défaut : branches PHP maintenues (`VERSIONS="8.2 8.3 8.4"`). Les EOL passent par `LEGACY_VERSIONS`, documenté comme non supporté.
- Versions des outils externes : uniquement dans `versions.env` (URLs complètes, suivies par Renovate). Vérifier avec `task versions:check`, mettre à jour avec `task versions:update` (URLs vérifiées avant écriture). Ne pas hardcoder de version dans le Taskfile.
- Toute nouvelle variante doit avoir son smoke test dans `test:image` et être ajoutée à `test:sample`.
- Source unique du « quoi builder » : `missing.json` produit par `task check:missing` (diff php.net vs tags Docker Hub). Pas de cache committé, pas d'édition manuelle.
- `task push` est interactif (confirmation, `PUSH_CONFIRM=1` pour bypass) et pousse tag par tag : ne jamais réintroduire `docker push -a` aveugle.
- CI : Trivy bloque sur `HIGH,CRITICAL` ; les images poussées sont signées (cosign keyless) avec SBOM SPDX.

## Release (nouvelles versions PHP)

Les builds sont déclenchés uniquement par `release.yml` (cron quotidien + manuel) :

1. `task check:missing VERSIONS="8.2 8.3 8.4"` — compare php.net aux tags Docker Hub, écrit `missing.json` (`{include: [{version, number, folder, variant}]}`).
2. Un job par entrée manquante : `create` → `build:image` → `test:image` → Trivy → `push:image`.
3. `supply-chain` : SBOM + signature des tags poussés.

`task exec` / `task push` restent disponibles pour un run manuel complet (avec skip des tags existants).
