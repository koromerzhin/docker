# base image
FROM koromerzhin/nodejs:15.0.1

# set working directory
WORKDIR /app

# install and cache app dependencies
RUN npm install -g @angular/cli@10.2.0

# start app
CMD ng serve --host 0.0.0.0 --disableHostCheck
