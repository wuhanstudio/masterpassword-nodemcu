FROM nginx:alpine
MAINTAINER wuhanstudio 

COPY ./http /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
