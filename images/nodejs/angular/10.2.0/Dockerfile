# base image
FROM node:15.1.0 AS build-nodejs-15.1.0

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start

FROM build-nodejs-15.1.0 AS build-angular-10.2.0

# install and cache app dependencies
RUN npm install -g @angular/cli@10.2.0

# start app
CMD ng serve --host 0.0.0.0 --disableHostCheck
