# base image
FROM node:13.8.0

# set working directory
WORKDIR /app

RUN npm install -g @angular/cli@10.2.0

# start app
CMD ng serve --host 0.0.0.0 --disableHostCheck
