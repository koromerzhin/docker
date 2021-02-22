# This is a dockerized version of a server that you can easily deploy somewhere.
# If you don't want server rendering, you can safely delete this file.

FROM koromerzhin/nodejs:15.1.0

# Installs latest Chromium (85) package.
RUN apt-get update && apt-get install -y chromium --no-install-recommends
RUN apt-get install -y chromium --no-install-recommends
RUN apt-get install -y ca-certificates --no-install-recommends
RUN apt-get install -y ttf-freefont --no-install-recommends
RUN apt-get install -y ffmpeg --no-install-recommends

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

EXPOSE 8000

CMD ["npm", "run", "server"]
