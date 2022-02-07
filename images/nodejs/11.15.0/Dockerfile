# base image
FROM node:11.15.0 AS build-nodejs-11.15.0

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
