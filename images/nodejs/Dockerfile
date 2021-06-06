# base image
FROM node:16.3.0

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start
