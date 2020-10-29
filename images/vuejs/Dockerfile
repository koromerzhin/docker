# base image
FROM node:13.14.0

# set working directory
WORKDIR /app

# install and cache app dependencies
RUN npm install -g @vue/cli@4.2.2

# start app
CMD npm run serve