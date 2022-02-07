# base image
FROM node:4.9.1 AS build-nodejs-4.9.1

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
