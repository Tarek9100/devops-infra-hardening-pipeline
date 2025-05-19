FROM nginx:latest
COPY roles/apache_setup/files/index.html /usr/share/nginx/html/index.html
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

