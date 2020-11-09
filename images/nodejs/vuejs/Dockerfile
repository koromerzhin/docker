# base image
FROM koromerzhin/nodejs:15.1.0

# set working directory
WORKDIR /app

# install and cache app dependencies
RUN npm install -g @vue/cli@4.5.8

# start app
CMD npm run serve
