# base image
FROM node:15.1.0 AS build-nodejs-15.1.0

# set working directory
WORKDIR /app

ADD package.json /app/

RUN npm install

# start app
CMD npm run start

FROM build-nodejs-15.1.0 AS build-remotion-1.3.0

# Installs latest Chromium (85) package.
RUN apt-get update && apt-get install -y \
    chromium \
    ca-certificates \
    ttf-freefont \
    ffmpeg \
    --no-install-recommends

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

EXPOSE 8000

CMD ["npm", "run", "server"]
