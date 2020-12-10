FROM node:14.15.1

WORKDIR /client-app

COPY package.json yarn.lock ./

RUN yarn install

CMD ["yarn", "dev"]