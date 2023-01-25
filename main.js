const { program } = require('commander');
const { exec } = require('child_process');
let folder = 'images';

const fs = require('fs');
let cmd = [];

program
    .name('main.js')
  .description('CLI to build image docker');
    
program.command('build:django')
  .description('build django images')
  .option('--folder <folder>', 'images version')
  .action(async (options) => {
    selectfolder = (process.env.npm_config_folder != undefined) ? process.env.npm_config_folder : options.folder;
    console.log('folder', selectfolder);
    folder += '/django';
    const versions = fs.readdirSync(folder, { withFileTypes: true })
    .filter((item) => item.isDirectory())
    .map((item) => item.name);
    versions.forEach(version => {
      if (selectfolder == undefined || selectfolder == version) {
        cmd.push('docker build -t koromerzhin/django:' + version + ' images/django/' + version + ' --target build-django-' + version);
        if (versions[versions.length - 1] == version) {
          cmd.push('docker image tag koromerzhin/django:' + version + ' koromerzhin/django:latest');
        }
      }
    });
    saveInFile(cmd, 'django', selectfolder);
  });

  program.command('build:php:fpm')
  .description('build php images')
  .option('--folder <folder>', 'images version')
  .action(async (options) => {
    selectfolder = (process.env.npm_config_folder != undefined) ? process.env.npm_config_folder : options.folder;
    console.log('folder', selectfolder);
    folder += '/php';
    const versions = fs.readdirSync(folder, { withFileTypes: true })
      .filter((item) => item.isDirectory())
      .map((item) => item.name);
      versions.forEach(version => {
        if (selectfolder == undefined || selectfolder == version) {
          cmd.push('docker build -t koromerzhin/php:' + version + '-fpm images/phpfpm/' + version + ' --target build-phpfpm-' + version);
          cmd.push('docker build -t koromerzhin/php:' + version + '-fpm-xdebug images/phpfpm/' + version + ' --target build-phpfpm-xdebug-' + version);
          if (versions[versions.length - 1] == version) {
            cmd.push('docker image tag koromerzhin/php:' + version + '-fpm koromerzhin/php:fpm-latest');
            cmd.push('docker image tag koromerzhin/php:' + version + '-fpm-xdebug koromerzhin/php:fpm-latest-xdebug');
          }
        }
      });
      saveInFile(cmd, 'php-fpm', selectfolder);
  });
program.command('build:php:apache')
.description('build php images')
.option('--folder <folder>', 'images version')
.action(async (options) => {
  selectfolder = (process.env.npm_config_folder != undefined) ? process.env.npm_config_folder : options.folder;
  console.log('folder', selectfolder);
  folder += '/php';
  const versions = fs.readdirSync(folder, { withFileTypes: true })
    .filter((item) => item.isDirectory())
    .map((item) => item.name);
    versions.forEach(version => {
      if (selectfolder == undefined || selectfolder == version) {
        cmd.push('docker build -t koromerzhin/php:' + version + '-apache images/php-apachep/' + version + ' --target build-php-apache-' + version);
        cmd.push('docker build -t koromerzhin/php:' + version + '-apache-xdebug images/php-apache/' + version + ' --target build-php-apache-xdebug-' + version);
        if (versions[versions.length - 1] == version) {
          cmd.push('docker image tag koromerzhin/php:' + version + '-apache koromerzhin/php:apache-latest');
          cmd.push('docker image tag koromerzhin/php:' + version + '-apache-xdebug koromerzhin/php:apache-latest-xdebug');
        }
      }
    });
    saveInFile(cmd, 'php-apache', selectfolder);
});

function saveInFile(cmd, image, selectfolder)
{
  let file = `build-${image}`;
  if (selectfolder != undefined) {
    file += `-${selectfolder}`
  }
  file += '.sh';
  let content = cmd.join('\n');
  fs.writeFile(file, '#!/bin/bash -x\n'+content, function(err) {
    if(err) {
        return console.log(err);
    }
    console.log(`The file ${file} was saved!`);
    exec(`chmod +x ${file}`);
});
}

program.parse();