# base image
FROM node:14.19.0 AS build-nodejs-14.19.0

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
