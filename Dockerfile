# mj520/nginx-php
FROM registry.cn-hangzhou.aliyuncs.com/mj520/centos:7
MAINTAINER nginx-php
ENV phpV=php73
RUN yum install -y wget epel-release && \
    rpm -Uvh https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm && \
    rpm -Uvh https://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-* && \
    yum makecache && \
    yum install -y net-tools inotify-tools openssh-clients && \
    yum install -y nginx  && \
    groupmod --gid 80 --new-name www nginx && \
    usermod --uid 80 --home /data/www --gid 80 --login www --shell /sbin/nologin --comment www nginx && \
    echo 'nginx installed.' && nginx -v && \
    yum install -y \
    ${phpV}-php \
    ${phpV}-php-bcmath \
    ${phpV}-php-cli \
    ${phpV}-php-common \
    ${phpV}-php-devel \
    ${phpV}-php-fpm \
    ${phpV}-php-gd \
    ${phpV}-php-json \
    ${phpV}-php-mbstring \
    ${phpV}-php-mysqlnd \
    ${phpV}-php-opcache \
    ${phpV}-php-pdo \
    ${phpV}-php-process \
    ${phpV}-php-xml \
    ${phpV}-php-pecl-zip \
    ${phpV}-php-pecl-mongodb \
    ${phpV}-php-pecl-imagick \
    ${phpV}-php-pecl-redis5 \
    ${phpV}-php-pecl-protobuf \
    ${phpV}-php-pecl-grpc \
    ${phpV}-php-pecl-psr \
    ${phpV}-php-phalcon3 \
    ${phpV}-php-pecl-swoole4 && \
    ln -sfF /opt/remi/${phpV}/enable /etc/profile.d/${phpV}-paths.sh && \
    ln -sfF /opt/remi/${phpV}/root/usr/bin/{pecl,phar,php,php-cgi,php-config,phpize} /usr/local/bin/. && \
    mv -f /etc/opt/remi/${phpV}/php.ini /etc/php.ini && ln -s /etc/php.ini /etc/opt/remi/${phpV}/php.ini && \
    rm -rf /etc/php.d && mv /etc/opt/remi/${phpV}/php.d /etc/. && ln -s /etc/php.d /etc/opt/remi/${phpV}/php.d && \
    mkdir -p /data/conf && touch php.ini && ln -s /data/conf/php.ini /etc/php.d/zz.php.ini && \
    echo 'PHP installed.' && php --version && \
    wget https://getcomposer.org/composer.phar -O /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer && \
    echo 'composer installed.' && composer --version && \
    composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ && \
    yum clean all && rm -rf /tmp/yum*
ADD container-files /
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    chmod +x /docker-entrypoint.sh && \
    echo -e "[inet_http_server]\nport=127.0.0.1:9001\n[include]\nfiles = /etc/supervisord.conf.d/*.conf /data/conf/supervisord.conf.d/*.conf" \
        >> /etc/supervisord.conf && \
    chmod +x /docker-entrypoint.sh /supervisor* && mv /supervisor* /usr/bin/
WORKDIR /data
VOLUME [ "/data" ]
ENTRYPOINT [ "/docker-entrypoint.sh" ]
EXPOSE 80 443 9000
CMD /usr/bin/supervisord -c /etc/supervisord.conf