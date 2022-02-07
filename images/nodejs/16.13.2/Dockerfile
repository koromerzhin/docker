# base image
FROM node:16.13.2 AS build-nodejs-16.13.2

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
