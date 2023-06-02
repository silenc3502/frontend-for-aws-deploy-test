FROM arm64v8/node:18 AS builder

# Vue.js 애플리케이션을 정적 파일로 제공할 디렉토리를 생성합니다.
RUN mkdir /app
WORKDIR /app
ADD . /app/

COPY package*.json
RUN npm install
RUN npm audit fix --force
COPY . .
RUN npm run build

# 베이스 이미지를 ARM64 아키텍처용 nginx 이미지로 설정합니다.
FROM arm64v8/nginx:latest

# Vue.js 정적 파일을 컨테이너의 /app 디렉토리로 복사합니다.
COPY --from=builder /app/dist/ /app

# nginx 설정 파일을 컨테이너의 설정 디렉토리로 복사합니다.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 컨테이너의 80번 포트를 노출합니다.
EXPOSE 80

# nginx를 실행합니다.
CMD ["nginx", "-g", "daemon off;"]