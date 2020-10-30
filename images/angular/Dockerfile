# base image
FROM node:13.14.0

# set working directory
WORKDIR /app

RUN npm install -g @angular/cli@8.3.21

# start app
CMD ng serve --host 0.0.0.0 --disableHostCheck
