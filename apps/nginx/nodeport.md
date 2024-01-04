

```bash
sudo apt install nginx -y
```

```bash
sudo vim /etc/nginx/conf.d/http-nodeport.conf
```

```conf
server {
    listen 80;
    listen [::]:80;
    server_name <DOMAIN-FQDN>;
    #server_name localhost;
    location / {
        # Forward 80 to NodePort portnumber
        proxy_pass http://<NODE_IP>:<NODEPORT_FOR_HTTP>;
        # Forward host info.
        proxy_set_header Host $host;
        # Avoid http error(426) by setting http version
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

```bash
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
```