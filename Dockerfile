FROM node:18.14.1
#FROM node:lts-alpine

RUN npm i -g http-server
RUN mkdir -p /app
WORKDIR /app
ADD . /app/

COPY package*.json ./
RUN npm i
RUN npm audit fix --force
COPY . .
RUN npm run build

CMD ["http-server","dist"]