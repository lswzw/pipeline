FROM busybox:latest
LABEL maintainer="lswzw"
EXPOSE 80/tcp
COPY index.html /home
CMD /bin/httpd -f -h /home
