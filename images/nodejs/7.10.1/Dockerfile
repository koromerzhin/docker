# base image
FROM node:7.10.1 AS build-nodejs-7.10.1

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
