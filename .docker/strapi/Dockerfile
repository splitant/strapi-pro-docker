ARG NODE_VERSION

FROM node:${NODE_VERSION}

RUN apt-get update && apt-get install -y \
    libvips-dev \
    vim \
    unzip \
    wget

ARG NODE_ENV=development

ENV NODE_ENV=${NODE_ENV}

WORKDIR /home/node/

COPY --chown=node:node ./backend/package.json ./backend/yarn.lock ./

ENV PATH /home/node/node_modules/.bin:$PATH

USER node

RUN yarn config set network-timeout 600000 -g && yarn install

RUN mkdir -p /home/node/app
WORKDIR /home/node/app

COPY --chown=node:node ./backend/ .

RUN ["yarn", "build"]

EXPOSE 1337
