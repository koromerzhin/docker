# base image
FROM node:6.17.1 AS build-nodejs-6.17.1

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
