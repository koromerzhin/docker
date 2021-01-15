# base image
FROM koromerzhin/nodejs:15.1.0

# set working directory
WORKDIR /app

# install and cache app dependencies
RUN npm install -g @quasar/cli@1.1.3

# start app
CMD quasar dev
