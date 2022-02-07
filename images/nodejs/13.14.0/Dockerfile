# base image
FROM node:13.14.0 AS build-nodejs-13.14.0

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
