# base image
FROM koromerzhin/nodejs:15.1.0

# install and cache app dependencies
RUN npm install -g @angular/cli@10.2.0

# start app
CMD ng serve --host 0.0.0.0 --disableHostCheck
