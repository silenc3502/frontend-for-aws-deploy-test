FROM node:18.14.1 as build-stage
#FROM node:lts-alpine

RUN mkdir -p /app
WORKDIR /app
ADD . /app/

COPY package*.json ./
RUN npm i
RUN npm audit fix --force
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY nginx.conf /etc/nginx/conf.d/default.conf

#COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]