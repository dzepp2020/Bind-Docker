#FROM ubuntu:16.04
FROM ubuntu

RUN apt-get -y update && apt-get -y install bind9 dnstop

EXPOSE 53

CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "bind"]
