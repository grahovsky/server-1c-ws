FROM centos:centos7 as prepare

WORKDIR /tmp

COPY distr/* ./

RUN for file in *.tar.gz; do tar -zxf "$file"; done \
  && rm -rf *-nls-* *-crs-* \
  && rm -rf *.tar.gz

FROM centos:centos7 as base

# install epel
RUN yum -y --setopt=tsflags=nodocs install epel-release && \
    # install dependences
    yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install fontconfig \
    # glibc-langpack-en \
    httpd \
    # install krb
    krb5-workstation krb5-libs krb5-auth-dialog mod_auth_kerb && \
    yum clean all

# locale
ENV LANG ru_RU.UTF-8
ENV LANGUAGE=ru_RU.UTF-8
RUN localedef -f UTF-8 -i ru_RU ru_RU.UTF-8

# add rpm
COPY --from=prepare /tmp/*.rpm /tmp/
# install 1c components
RUN yum localinstall -y /tmp/*.rpm && yum clean all && rm -f /tmp/*.rpm

# Add path 1cv8
ENV PATH="/opt/1cv8/x86_64/8.3.18.1698:${PATH}"

# expose ports
EXPOSE 8080

COPY run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

RUN chmod -R g+w /etc/httpd /run/httpd /var/www \
    && chmod -R g+rwx /var/log

# USER apache

CMD ["/run-httpd.sh"]
# webinst -publish -apache24 -connstr "Srvr=server-1c:30041;Ref=base-1c" -wsdir base-1c -dir /var/www/base-1c -confpath /etc/httpd/conf/httpd.conf 

