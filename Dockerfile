# 빌드 스테이지
FROM ghcr.io/cirruslabs/flutter:3.10.0-1.1.pre AS build-stage

# 앱 코드 복사
WORKDIR /app
COPY . .

# 앱 빌드
RUN flutter build web

# 런타임 스테이지
FROM nginx:1.21.4-alpine AS runtime-stage

# Nginx 설정 파일 수정
RUN rm /etc/nginx/conf.d/default.conf
COPY web/nginx.conf /etc/nginx/conf.d

# 앱 빌드 결과물 복사
COPY --from=build-stage /app/build/web /usr/share/nginx/html

# 포트 설정
ENV PORT 8080
EXPOSE 8080

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]
