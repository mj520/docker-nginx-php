# mj520/nginx-php
FROM centos:7
MAINTAINER nginx-php
ENV phpV=php55
RUN yum install -y wget epel-release && \
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
    rpm -Uvh https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm && \ 
    rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm && \ 
    rpm -Uvh https://repo.mysql.com/mysql57-community-release-el7-11.noarch.rpm && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-* && \ 
    yum install -y iproute net-tools inotify-tools which jq rsync && \
    yum install -y openssh-clients mysql-community-client ImageMagick zbar && \ 
    yum -y install supervisor && \ 
    echo "files = /etc/supervisord.conf.d/*.conf /data/conf/supervisord.conf.d/*.conf" >> /etc/supervisord.conf && \
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
    ${phpV}-php-gmp \
    ${phpV}-php-intl \
    ${phpV}-php-json \
    ${phpV}-php-mbstring \
    ${phpV}-php-mcrypt \
    ${phpV}-php-mysqlnd \
    ${phpV}-php-opcache \
    ${phpV}-php-pdo \
    ${phpV}-php-pear \
    ${phpV}-php-process \
    ${phpV}-php-pspell \
    ${phpV}-php-xml \
    ${phpV}-php-pecl-imagick \
    ${phpV}-php-pecl-mysql \
    ${phpV}-php-pecl-uploadprogress \
    ${phpV}-php-pecl-uuid \
    ${phpV}-php-pecl-zip \
    ${phpV}-php-pecl-redis4 \
    ${phpV}-php-pecl-memcache \
    ${phpV}-php-phalcon3 \
    ${phpV}-php-pecl-swoole2 && \
    ln -sfF /opt/remi/${phpV}/enable /etc/profile.d/${phpV}-paths.sh && \
    ln -sfF /opt/remi/${phpV}/root/usr/bin/{pear,pecl,phar,php,php-cgi,php-config,phpize} /usr/local/bin/. && \ 
    mv -f /opt/remi/${phpV}/root/etc/php.ini /etc/php.ini && ln -s /etc/php.ini /opt/remi/${phpV}/root/etc/php.ini && \
    rm -rf /etc/php.d && mv /opt/remi/${phpV}/root/etc/php.d /etc/. && ln -s /etc/php.d /opt/remi/${phpV}/root/etc/php.d && \
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
    chmod +x /docker-entrypoint.sh
VOLUME [ "/data" ]
ENTRYPOINT [ "/docker-entrypoint.sh" ]
EXPOSE 80 443 9000
CMD /usr/bin/supervisord -n -c /etc/supervisord.conf