FROM docker.io/library/alpine:latest

# Steps done in one RUN layer:
# - Install upgrades and new packages
# - Remove generic host keys, entrypoint generates unique keys
RUN apk update && apk upgrade \
    && apk add \
      proftpd \
      proftpd-mod_sftp \
      proftpd-utils \
      openssh-keygen \
    && rm -rf /var/cache/apk/*

COPY files/proftpd.conf /etc/proftpd/proftpd.conf
COPY files/sftp.conf /etc/proftpd/conf.d/sftp.conf
COPY files/entrypoint.sh /usr/local/bin/

EXPOSE 2222

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
