const { program } = require("commander");
const { exec } = require("child_process");
let folder = "images";
const fs   = require("fs");
program.name("main.js").description("CLI to build image docker");

function getSelectfolder(options) {
  const selectfolder =
    process.env.npm_config_folder != undefined
      ? process.env.npm_config_folder
      : options.folder;

  return selectfolder;
}

function getLatest(options) {
  const latest =
    process.env.npm_config_latest != undefined
      ? process.env.npm_config_latest
      : options.latest;

  return latest;
}

function getXdebug(options) {
  const xdebug =
    process.env.npm_config_xdebug != undefined
      ? process.env.npm_config_xdebug
      : options.xdebug;

  return xdebug;
}

function getSelect(options) {
  const only =
    process.env.npm_config_select != undefined
      ? process.env.npm_config_select
      : options.select;

  return only;
}

function getVersions(folder) {
  const versions = fs
    .readdirSync(`images/${folder}`, { withFileTypes: true })
    .filter((item) => item.isDirectory())
    .map((item) => item.name);

  return versions;
}

function setVersionImage(selectfolder, version) {
  const versionimage = selectfolder == undefined ? version : selectfolder;

  return versionimage;
}

program
  .command("build:php")
  .description("build php images")
  .option("--folder <folder>", "images version")
  .option("--latest", "latest")
  .option("--select", "select")
  .action(async (options) => {
    const selectfolder = getSelectfolder(options);
    if (getSelect(options) == 'phpfpm' || getSelect(options) == undefined) {
      cmdbuild = [];
      cmdtag = [];
      versions = getVersions("phpfpm");
      versions.forEach((version) => {
        let versionimage = setVersionImage(selectfolder, version);
        if (
          selectfolder == undefined ||
          selectfolder == version ||
          selectfolder.split(version).length - 1 == 1
        ) {
          cmdbuild.push(`mkdir -p build/phpfpm/${versionimage}`);
          cmdbuild.push(
            `cp images/phpfpm/${version}/Dockerfile build/phpfpm/${versionimage}/Dockerfile`
          );
          cmdbuild.push(
            `sed -i 's/VERSIONIMAGE/php:${versionimage}-fpm/' build/phpfpm/${versionimage}/Dockerfile`
          );
          cmdbuild.push(
            `docker build -t koromerzhin/php:${versionimage}-fpm build/phpfpm/${versionimage} --target build-phpfpm`
          );
          cmdbuild.push(
            `docker build -t koromerzhin/php:${versionimage}-fpm-wordpress build/phpfpm/${versionimage} --target build-phpfpm-wordpress`
          );
          cmdbuild.push(
            `docker build -t koromerzhin/php:${versionimage}-fpm-symfony build/phpfpm/${versionimage} --target build-phpfpm-symfony`
          );
          if (getXdebug(options) == 'on') {
            cmdbuild.push(
              `docker build -t koromerzhin/php:${versionimage}-fpm-xdebug build/phpfpm/${versionimage} --target build-phpfpm-xdebug`
            );
            cmdbuild.push(
              `docker build -t koromerzhin/php:${versionimage}-fpm-wordpress-xdebug build/phpfpm/${versionimage} --target build-phpfpm-wordpress-xdebug`
            );
            cmdbuild.push(
              `docker build -t koromerzhin/php:${versionimage}-fpm-symfony-xdebug build/phpfpm/${versionimage} --target build-phpfpm-symfony-xdebug`
            );
          }
          if (getLatest(options) == 'on') {
            cmdtag.push(
              `docker image tag koromerzhin/php:${versionimage}-fpm koromerzhin/php:fpm-latest`
            );
            cmdtag.push(
              `docker image tag koromerzhin/php:${versionimage}-fpm-wordpress koromerzhin/php:fpm-wordpress-latest`
            );
            cmdtag.push(
              `docker image tag koromerzhin/php:${versionimage}-fpm-symfony koromerzhin/php:fpm-symfony-latest`
            );
            if (getXdebug(options) == 'on') {
              cmdtag.push(
                `docker image tag koromerzhin/php:${versionimage}-fpm-wordpress-xdebug koromerzhin/php:fpm-latest-wordpress-xdebug`
              );
              cmdtag.push(
                `docker image tag koromerzhin/php:${versionimage}-fpm-symfony-xdebug koromerzhin/php:fpm-latest-symfony-xdebug`
              );
              cmdtag.push(
                `docker image tag koromerzhin/php:${versionimage}-fpm-xdebug koromerzhin/php:fpm-latest-xdebug`
              );
            }
          }
        }
      });
      saveInFile('build', cmdbuild, "fpm", selectfolder);
      saveInFile('tag', cmdtag, "fpm", selectfolder);
    }
    if (getSelect(options) == 'apache' || getSelect(options) == undefined) {
      cmdbuild = [];
      cmdtag = [];
      versions = getVersions("php-apache");
      versions.forEach((version) => {
        let versionimage = setVersionImage(selectfolder, version);
        if (
          selectfolder == undefined ||
          selectfolder == version ||
          selectfolder.split(version).length - 1 == 1
        ) {
          cmdbuild.push(`mkdir -p build/php-apache/${versionimage}`);
          cmdbuild.push(
            `cp images/php-apache/${version}/Dockerfile build/php-apache/${versionimage}/Dockerfile`
          );
          cmdbuild.push(
            `sed -i 's/VERSIONIMAGE/php:${versionimage}-apache/' build/php-apache/${versionimage}/Dockerfile`
          );
          cmdbuild.push(
            `docker build -t koromerzhin/php:${versionimage}-apache build/php-apache/${versionimage} --target build-php-apache`
          );
          cmdbuild.push(
            `docker build -t koromerzhin/php:${versionimage}-apache-wordpress build/php-apache/${versionimage} --target build-php-apache-wordpress`
          );
          cmdbuild.push(
            `docker build -t koromerzhin/php:${versionimage}-apache-symfony build/php-apache/${versionimage} --target build-php-apache-symfony`
          );
          if (getXdebug(options) == 'on') {
            cmdbuild.push(
              `docker build -t koromerzhin/php:${versionimage}-apache-xdebug build/php-apache/${versionimage} --target build-php-apache-xdebug`
            );
            cmdbuild.push(
              `docker build -t koromerzhin/php:${versionimage}-apache-wordpress-xdebug build/php-apache/${versionimage} --target build-php-apache-wordpress-xdebug`
            );
            cmdbuild.push(
              `docker build -t koromerzhin/php:${versionimage}-apache-symfony-xdebug build/php-apache/${versionimage} --target build-php-apache-symfony-xdebug`
            );
          }
          if (getLatest(options) == 'on') {
            cmdtag.push(
              `docker image tag koromerzhin/php:${versionimage}-apache koromerzhin/php:apache-latest`
            );
            cmdtag.push(
              `docker image tag koromerzhin/php:${versionimage}-apache-wordpress koromerzhin/php:apache-wordpress-latest`
            );
            cmdtag.push(
              `docker image tag koromerzhin/php:${versionimage}-apache-symfony koromerzhin/php:apache-symfony-latest`
            );
            if (getXdebug(options) == 'on') {
              cmdtag.push(
                `docker image tag koromerzhin/php:${versionimage}-apache-xdebug koromerzhin/php:apache-latest-xdebug`
              );
              cmdtag.push(
                `docker image tag koromerzhin/php:${versionimage}-apache-wordpress-xdebug koromerzhin/php:apache-wordpress-latest-xdebug`
              );
              cmdtag.push(
                `docker image tag koromerzhin/php:${versionimage}-apache-symfony-xdebug koromerzhin/php:apache-symfony-latest-xdebug`
              );
            }
          }
        }
      });
      saveInFile('build', cmdbuild, "php-apache", selectfolder);
      saveInFile('tag', cmdtag, "php-apache", selectfolder);
    }
  });

function saveInFile(type, cmd, image, selectfolder) {
  let file = `${type}-${image}`;
  if (selectfolder != undefined) {
    file += `-${selectfolder}`;
  }
  file += ".sh";
  let content = cmd.join("\n");
  fs.writeFile(file, "#!/bin/bash -x\n" + content, function (err) {
    if (err) {
      return console.log(err);
    }
    console.log(`The file ${file} was saved!`);
    exec(`chmod +x ${file}`);
  });
}

program.parse();
