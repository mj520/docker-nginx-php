# Nginx + PHP-FPM docker container

This is a [mj520/nginx-php](https://registry.hub.docker.com/u/mj520/nginx-php/)
docker container with Nginx + PHP-FPM from centos:7 use supervisor.

#### - Nginx 1.14+ stream
```
--cap-add=SYS_PTRACE #https://www.xyhtml5.com/25471.html
/etc/nginx/fastcgi_params is default
php PATH_INFO fix See default.conf below for details
```

#### - Php version
|pull path|version|build|
|---|---|----|
|mj520/nginx-php:latest |php73|master branch |
|mj520/nginx-php:php74 |php74|php74 branch |    
|mj520/nginx-php:php73 |php73|php73 branch |
|mj520/nginx-php:php72 |php72|php72 branch |
|mj520/nginx-php:php71 |php71|php71 branch |
|mj520/nginx-php:php70 |php70|php70 branch |
|mj520/nginx-php:php56 |php56|php56 branch |
|mj520/nginx-php:php55 |php55|php55 branch |


#### - Install Packages redis4+ swoole4 phalcon3 composer...
```
 bcmath cli common devel fpm gd gmp intl 
 json mbstring mcrypt mysqlnd opcache pdo 
 pear process pspell xml pecl-imagick 
 pecl-mysql pecl-uploadprogress 
 pecl-uuid pecl-zip pecl-redis4+
 pecl-grpc phalcon3 pecl-swoole4

 Note:php5+ Only use pecl-swoole2、php7+ use pecl-swoole4
```

#### - Directory structure
```
/data/conf 
    php.ini  # replace php config
    php-fpm*.conf # replace php-fpm config
    supervisord.conf.d/*.conf # supervisord config
    nginx/*.conf # replace nginx http config and vhost
    nginx/*.stream # replace nginx stream config
/data/www # user www home
/data/logs/ # Nginx, PHP logs
/data/tmp/php/ # PHP temp directories
```

#### - Dev tools and use yum repo install and supervisor run nginx php
```
    iproute net-tools openssh-clients inotify-tools which jq rsync mysql-community-client ImageMagick zbar
```

## Usage
#### Default China Time Zone use Asia/Shanghai -e TZ= change
```
docker run --name=nginx-php -d --privileged=true -p 80:80 -v path/data:/data mj520/nginx-php

#vi /data/conf/nginx/default.conf #for default nginx vhost
server {
    listen       80;
    server_name localhost;
    root /data/www/default;
    index index.html index.htm index.php;
 
    charset utf-8;
    location ~ \.html$ {
      expires -1;
    }
    location ~ \.php$ {
        # php config
        include               fastcgi_params;
        fastcgi_pass          127.0.0.1:9000;
        fastcgi_split_path_info       ^(.+\.php)(/.+)$;
        fastcgi_param PATH_INFO       $fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param APPLICATION_ENV production;#development your ENV
    }
}
#echo "<?php phpinfo();" > /data/www/default/index.php
#open http://CONTAINER_IP:PORT/ #in the browser
```
#### Note nginx-reload windows inotify-tools It may be ineffective.
```
If your website directory needs write permission, please run it and execute
#docker exec -it nginx-php chown www:www -R path
    reason on windows When there are many files
    docker toolbox chown -R /data/www very slow, docker toolbox has permission.
    nginx-php is my container name
php session.save default /tmp, on windows session_save_path("volume/dir"); 
    Warning: session_start(): Session data file is not created by your uid in ...
    Warning: session_start(): Failed to read session data: files (path: volume/dir) in ...
    please change to default
```
getenv临时不生效 run -e 或者 修改 /etc/profile 后重启容器
进入容器不生效 在~/.bashrc里面加一句source /etc/profile有些变量不生效

#### xdebug for /data/conf/php.ini
```
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_port=9003
xdebug.client_host=host.docker.internal
xdebug.remote_handler=dbgp
xdebug.idekey=PHPSTORM
```
#Thinks