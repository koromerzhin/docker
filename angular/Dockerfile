# base image
FROM node:13.8.0

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /apps/node_modules/.bin:$PATH

# install and cache app dependencies
COPY apps/package.json /app/package.json
RUN npm install
RUN npm install -g @angular/cli@8.3.21

# add app
COPY apps/ /app

# start app
CMD ng serve --host 0.0.0.0 --disableHostCheck
