# base image
FROM node:17.4.0 AS build-nodejs-15.14.0

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start

FROM build-nodejs-15.14.0 AS build-angular-11.2.18

# install and cache app dependencies
RUN npm install -g @angular/cli@11.2.18

# start app
CMD ng serve --host 0.0.0.0 --disableHostCheck
