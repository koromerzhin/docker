const { program } = require("commander");
const { exec } = require("child_process");
let folder = "images";

const fs = require("fs");
let cmd = [];

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
  .action(async (options) => {
    const selectfolder = getSelectfolder(options);
    versions = getVersions("phpfpm");
    versions.forEach((version) => {
      let versionimage = setVersionImage(selectfolder, version);
      if (
        selectfolder == undefined ||
        selectfolder == version ||
        selectfolder.split(version).length - 1 == 1
      ) {
        cmd.push(`mkdir -p build/phpfpm/${versionimage}`);
        cmd.push(
          `cp images/phpfpm/${version}/Dockerfile build/phpfpm/${versionimage}/Dockerfile`
        );
        cmd.push(
          `sed -i 's/VERSIONIMAGE/php:${versionimage}-fpm/' build/phpfpm/${versionimage}/Dockerfile`
        );
        cmd.push(
          `docker build -t koromerzhin/php:${versionimage}-fpm build/phpfpm/${versionimage} --target build-phpfpm`
        );
        if (getXdebug(options) == 'on') {
          cmd.push(
            `docker build -t koromerzhin/php:${versionimage}-fpm-xdebug build/phpfpm/${versionimage} --target build-phpfpm-xdebug`
          );
        }
        if (getLatest(options) == 'on') {
          cmd.push(
            `docker image tag koromerzhin/php:${versionimage}-fpm koromerzhin/php:fpm-latest`
          );
          if (getXdebug(options) == 'on') {
            cmd.push(
              `docker image tag koromerzhin/php:${versionimage}-fpm-xdebug koromerzhin/php:fpm-latest-xdebug`
            );
          }
        }
      }
    });
    versions = getVersions("php-apache");
    versions.forEach((version) => {
      let versionimage = setVersionImage(selectfolder, version);
      if (
        selectfolder == undefined ||
        selectfolder == version ||
        selectfolder.split(version).length - 1 == 1
      ) {
        cmd.push(`mkdir -p build/php-apache/${versionimage}`);
        cmd.push(
          `cp images/php-apache/${version}/Dockerfile build/php-apache/${versionimage}/Dockerfile`
        );
        cmd.push(
          `sed -i 's/VERSIONIMAGE/php:${versionimage}-apache/' build/php-apache/${versionimage}/Dockerfile`
        );
        cmd.push(
          `docker build -t koromerzhin/php:${versionimage}-apache build/php-apache/${versionimage} --target build-php-apache`
        );
        if (getXdebug(options) == 'on') {
        cmd.push(
          `docker build -t koromerzhin/php:${versionimage}-apache-xdebug build/php-apache/${versionimage} --target build-php-apache-xdebug`
        );
        if (getLatest(options) != undefined) {
          cmd.push(
            `docker image tag koromerzhin/php:${versionimage}-apache koromerzhin/php:apache-latest`
          );
          if (getXdebug(options) == 'on') {
            cmd.push(
              `docker image tag koromerzhin/php:${versionimage}-apache-xdebug koromerzhin/php:apache-latest-xdebug`
            );
          }
        }
      }
    });
    saveInFile(cmd, "php", selectfolder);
  });

function saveInFile(cmd, image, selectfolder) {
  let file = `build-${image}`;
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
