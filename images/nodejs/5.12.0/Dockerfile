# base image
FROM node:5.12.0 AS build-nodejs-5.12.0

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
