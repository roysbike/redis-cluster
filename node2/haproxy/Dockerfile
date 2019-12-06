FROM haproxy:alpine
RUN apk add perl
COPY haproxy.cfg .
RUN mkdir -p /etc/haproxy &&\
    cp haproxy.cfg /etc/haproxy/haproxy.cfg
COPY run.sh /run.sh
RUN chmod +x /run.sh
RUN /run.sh
CMD [ "haproxy", "-f", "/etc/haproxy/haproxy.cfg" ]