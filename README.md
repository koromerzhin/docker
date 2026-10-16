# Welcome to @koromerzhin/docker 👋

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000)
![Documentation](https://img.shields.io/badge/documentation-yes-brightgreen.svg)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/koromerzhin/docker/graphs/commit-activity)
![Continuous Integration](https://github.com/koromerzhin/docker/workflows/ci/badge.svg?branch=main)

> Usine à images Docker PHP : construit et publie `koromerzhin/php` **uniquement quand une nouvelle version PHP sort** (PHP 8.2 → 8.4, serveurs `apache` et `fpm`, 6 variantes).

## 🏠 [Homepage](https://github.com/koromerzhin/docker#readme)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

![All Contributors](https://img.shields.io/badge/all_contributors-6-orange.svg?style=flat-square)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

## Principe

Chaque jour, `task check:missing` compare les versions publiées sur php.net aux tags déjà présents sur Docker Hub. Seuls les tags manquants sont construits, testés (smoke tests + Trivy), poussés, puis signés (cosign) avec leur SBOM. Rien de nouveau → rien ne tourne.

## Need

Software:

- docker (Buildx recommandé)
- task ([Task](https://taskfile.dev))
- jq, curl
- npm (jscpd uniquement)

## Download

```sh
git clone --recurse-submodules git@github.com:koromerzhin/docker.git docker
cd docker
```

## Install

```sh
npm install
cp .env.example .env  # optionnel : surcharger VERSIONS, PLATFORMS, ...
```

## Tags publiés

`koromerzhin/php:<php>-<serveur>[-variante]` — ex. `koromerzhin/php:8.4.26-apache-wordpress`.

| Serveur | Port exposé | Variantes |
|---|---|---|
| `apache` | `80` | (base), `-xdebug`, `-wordpress`, `-wordpress-xdebug`, `-symfony`, `-symfony-xdebug` |
| `fpm` | `9000` | (base), `-xdebug`, `-wordpress`, `-wordpress-xdebug`, `-symfony`, `-symfony-xdebug` |

- PHP supportés par défaut : `8.2 8.3 8.4` (branches maintenues). Legacy EOL (`7.4 8.0 8.1`) via `LEGACY_VERSIONS`, non supporté.
- Base : images officielles `php:<version>-<serveur>`, extensions via `install-php-extensions` (2.12.1), `wp-cli` (2.12.0), `symfony-cli` (5.22.1, amd64 uniquement).
- `HEALTHCHECK php -v` embarqué (minimal, à surcharger au déploiement).

## Usage

```sh
docker run --rm koromerzhin/php:8.4-apache php -v
docker run -d -p 8080:80 -v "$PWD:/var/www" koromerzhin/php:8.4-apache
docker run --rm koromerzhin/php:8.4-apache wp --info --allow-root
docker run --rm koromerzhin/php:8.4-fpm symfony version
```

```yaml
# docker-compose.yml (apache)
services:
  php:
    image: koromerzhin/php:8.4-apache
    ports: ["8080:80"]
    volumes: ["./src:/var/www"]
```

## Commandes

```sh
task check:missing VERSIONS=8.4  # quels tags manquent ? (écrit missing.json)
task exec VERSIONS=8.4           # construit uniquement les tags manquants
task test:sample                 # smoke tests (php -v, wp, symfony, xdebug)
task push                        # pousse les images locales (confirmation requise)
task versions:check              # versions.env vs dernières releases GitHub
task versions:update             # met versions.env à jour (URLs vérifiées avant écriture)

npm run docker:build:php  # = task exec
npm run docker:push:php   # = task push
npm run test:images       # = task test:sample
npm run lint:duplication  # jscpd sur images/ + Taskfile.yml
npm run versions:check    # = task versions:check
```

Détail utile : `task push` liste les tags locaux et demande confirmation (`PUSH_CONFIRM=1` pour bypass non-interactif) ; `task build:image ... PLATFORMS=linux/amd64,linux/arm64` pour le multi-arch (variantes `symfony` = amd64 uniquement).

## Configuration

Variables (`.env`, voir `.env.example`) :

| Variable | Défaut | Rôle |
|---|---|---|
| `VERSIONS` | `8.2 8.3 8.4` | Branches PHP à traiter |
| `LEGACY_VERSIONS` | `7.4 8.0 8.1` | Branches EOL (build manuel explicite uniquement) |
| `PLATFORMS` | (vide = natif) | ex. `linux/amd64,linux/arm64` |
| `MISSING_FILE` | `missing.json` | Sortie de `check:missing`, source unique des builds |

Versions des outils embarqués (`versions.env`, suivi par Renovate) : `install-php-extensions`, `wp-cli`, `symfony-cli`. Template unique : `images/php/Dockerfile` (`ARG SERVER`, 6 stages `build-*`).

## Automatisation (CI)

| Workflow | Déclenchement | Rôle |
|---|---|---|
| `ci.yml` | push/PR sur `main`, `develop` | Contrôles rapides uniquement : jscpd, génération sample, URLs outils joignables. Aucun build ni push. |
| `release.yml` | cron quotidien 06:00 UTC + manuel | `detect` (tags manquants) → matrice `create → build → test → Trivy → push` par tag → `supply-chain` (SBOM SPDX + signature cosign keyless). |

Secrets requis : `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` (GitHub secrets, jamais versionnés).

## Vues images

- [php](https://hub.docker.com/r/koromerzhin/php)

## Author

👤 **koromerzhin**

- Website: [https://www.letoullec.fr](https://www.letoullec.fr)
- Twitter: [@koromerzhin](https://twitter.com/koromerzhin)
- Github: [@koromerzhin](https://github.com/koromerzhin)
- LinkedIn: [@koromerzhin](https://linkedin.com/in/koromerzhin)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!
Feel free to check
[issues page](https://github.com/koromerzhin/docker/issues).
You can also take a look at the
[contributing guide](https://github.com/koromerzhin/docker/blob/develop/CONTRIBUTING.md).

## Show your support

Give a ⭐️ if this project helped you!

## 📝 License

Copyright © 2019 [koromerzhin](https://github.com/koromerzhin).

This project is
[MIT](https://github.com/koromerzhin/docker/blob/develop/LICENSE) licensed.

## ✨ Contributors

Thanks goes to these wonderful people
([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/koromerzhin"><img src="https://avatars0.githubusercontent.com/u/308012?v=4" width="100px;" alt=""/><br /><sub><b>Le TOULLEC Martial</b></sub></a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.mend.io/free-developer-tools/renovate/"><img src="https://avatars.githubusercontent.com/u/25180681?v=4" width="100px;" alt=""/><br /><sub><b>Mend Renovate</b></sub></a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://restyled.io/"><img src="https://avatars.githubusercontent.com/u/65077583?v=4" width="100px;" alt=""/><br /><sub><b>Restyled Commits</b></sub></a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/apps/dependabot"><img src="https://avatars.githubusercontent.com/in/29110?v=4" width="100px;" alt=""/><br /><sub><b>dependabot[bot]</b></sub></a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/apps/renovate"><img src="https://avatars.githubusercontent.com/in/2740?v=4" width="100px;" alt=""/><br /><sub><b>renovate[bot]</b></sub></a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/apps/mend-bolt-for-github"><img src="https://avatars.githubusercontent.com/in/16809?v=4" width="100px;" alt=""/><br /><sub><b>mend-bolt-for-github[bot]</b></sub></a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors)
specification. Contributions of any kind welcome!

---

_This README was generated with ❤️ by
[readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
