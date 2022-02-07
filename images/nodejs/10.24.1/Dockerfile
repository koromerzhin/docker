# base image
FROM node:10.24.1 AS build-nodejs-10.24.1

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
