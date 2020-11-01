# base image
FROM koromerzhin/nodejs:15.0.1

# set working directory
WORKDIR /app

# install and cache app dependencies
RUN npm install -g @vue/cli@4.5.8

# start app
CMD npm run serve
