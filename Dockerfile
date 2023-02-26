#운영환경을 위한 Dockerfile
##1. 빌드 파일을 생성(Builder Stage)
##2. Nginx를 가동하고 첫 번째 단계에서 생선된 빌드폴더의 파일들을 웹 브라우저의 요청에 따라 제공(Run Stage)

#builder stage
FROM node:alpine as builder
#여기 FROM부터 다음 FROM 전 까지는 모두 builder stage라는 것을 명시
WORKDIR '/usr/src/app'
COPY package.json ./
RUN npm install
COPY ./ ./
RUN npm run build
#이곳의 목표는 빌드파일들을 생성하는 것
#생성된 파일과 폴더들은 /usr/src/app/build로 들어감

#run stage
FROM nginx
EXPOSE 80
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
#--from=builder: 다른 스테이지에 있는 파일을 복사할 때 다른 스테이지 이름 명시

#/usr/src/app/build /usr/share/nginx/html: builder stage에서 생성한 파일은 /usr/src/app/build에 생성되며,
##이 경로에 저장된 파일들을 /usr/share/nginx/html로 복사
##브라우저에서 HTTP요청이 올 때마다 Nginx가 알맞은 파일을 전달 할 수 있게 만듦

#/usr/share/nginx/html: 클라이언트의 요청이 올 때마다 Nginx가 알맞은 정적 파일을 제공하기 위해 이 장소로 빌드된 파일을 복사.

#실행 명령어: docker run -p 8080:80 bsy0530/docker-react-app