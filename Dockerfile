FROM fedora:latest

EXPOSE 80

ARG ZIP_FILE=limesurvey3.9.0+180604.zip
ARG SHA256SUM=729dd1d985e44943559e51632ad671244c078af6b225e84b7662186a76a1bec9
ARG LIMESURVEY_DIR=/var/www/limesurvey
ARG PHP_USER=apache

RUN dnf -y upgrade \
    && dnf -y install \
        mariadb-server \
        nginx \
        php-fpm \
        php-json \
        php-xml \
        php-mbstring \
        php-gd \
        php-pdo \
        php-mysqlnd \
        php-zip \
        php-zlib \
        php-ldap \
        php-imap \
        unzip \
    && dnf clean all

RUN cd $(dirname "${LIMESURVEY_DIR}") \
    && curl -o "${ZIP_FILE}" "https://download.limesurvey.org/latest-stable-release/${ZIP_FILE}" \
    && sha256sum "${ZIP_FILE}"  | grep ${SHA256SUM} \
    && unzip -q "${ZIP_FILE}" \
    && rm "${ZIP_FILE}" 
RUN chown -R "root:${PHP_USER}" "${LIMESURVEY_DIR}" \
    && chmod -R u=rwX,g=rwX,o=X "${LIMESURVEY_DIR}" \
    && chmod u=rwX,g=rwX,o=X "${LIMESURVEY_DIR}/tmp/" "${LIMESURVEY_DIR}/upload/" "${LIMESURVEY_DIR}/application/config/" \
    && mkdir /var/run/php-fpm/ \
    && usermod -aG apache nginx

VOLUME ["/var/lib/mysql/", "${LIMESURVEY_DIR}/upload/", "${LIMESURVEY_DIR}/application/config/"]

ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./php-fpm.conf /etc/php-fpm.conf 
ADD ./php-fpm-www.conf /etc/php-fpm.d/www.conf
ADD ./init_safe_install.sql ./init_users.sql ./run.sh /
ADD ./mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf 

CMD ["bash", "/run.sh"]
