# base image
FROM node:17.4.0 AS build-nodejs-12.22.10

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
