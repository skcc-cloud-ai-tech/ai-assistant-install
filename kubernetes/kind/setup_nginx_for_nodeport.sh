#!/bin/bash

apt update && apt install nginx -y

NGINX_CONF=/etc/nginx/conf.d/http-nodeport.conf
cat << 'EOF' > $NGINX_CONF  # 'EOF': prevent expanding envvar
# http
server {
    listen 8080;
    listen [::]:8080;
    server_name example.com;

    location / {
      proxy_pass http://localhost:30080/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# https
server {
    listen 8443;
    listen [::]:8443;
    server_name example.com;

    location / {
      proxy_pass http://localhost:30443/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# postgresql
server {
    listen 5432;
    listen [::]:5432;
    server_name example.com;

    location / {
      proxy_pass http://localhost:32543/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# opensearch
server {
    listen 9200;
    listen [::]:9200;
    server_name example.com;

    location / {
      proxy_pass http://localhost:30920/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# redis
server {
    listen 6379;
    listen [::]:6379;
    server_name example.com;

    location / {
      proxy_pass http://localhost:32637/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# qdrant-http
server {
    listen 6333;
    listen [::]:6333;
    server_name example.com;

    location / {
      proxy_pass http://localhost:32660/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# qdrant-grpc
server {
    listen 6334;
    listen [::]:6334;
    server_name example.com;

    location / {
      proxy_pass http://localhost:32661/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# milvus
server {
    listen 19530;
    listen [::]:19530;
    server_name example.com;

    location / {
      proxy_pass http://localhost:31953/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# faiss
server {
    listen 18080;
    listen [::]:18080;
    server_name example.com;

    location / {
      proxy_pass http://localhost:31880/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# reserved
server {
    listen 18081;
    listen [::]:18081;
    server_name example.com;

    location / {
      proxy_pass http://localhost:31881/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# reserved
server {
    listen 19090;
    listen [::]:19090;
    server_name example.com;

    location / {
      proxy_pass http://localhost:31990/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
# reserved
server {
    listen 19091;
    listen [::]:19091;
    server_name example.com;

    location / {
      proxy_pass http://localhost:31991/;
      proxy_set_header Host $http_host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
EOF

DOMAIN=${DOMAIN:-example.com}

sed -i \
  -e "s|server_name .*|server_name ${DOMAIN};|g" \
  $NGINX_CONF

systemctl enable nginx
systemctl daemon-reload
systemctl start nginx
# systemctl status nginx
