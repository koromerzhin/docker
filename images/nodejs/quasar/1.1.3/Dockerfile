# base image
FROM node:15.1.0 AS build-nodejs-15.1.0

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start

FROM build-nodejs-15.1.0 AS build-quasar-1.1.3

# install and cache app dependencies
RUN npm install -g @quasar/cli@1.1.3

# start app
CMD quasar dev