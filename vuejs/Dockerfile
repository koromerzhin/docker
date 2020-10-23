# base image
FROM node:13.8.0 as labstagvuejs

# set working directory
WORKDIR /app

# install and cache app dependencies
RUN npm install -g http-server@0.12.1
RUN npm install -g nodemon

RUN echo  "\"use strict\"; \
\
    setInterval(() => {\
    console.log(\"tick 2\");\
    }, 1000);\
    " > /index.js
RUN mkdir /dist

CMD nodemon /index.js