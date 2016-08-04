FROM 1and1internet/ubuntu-16-nginx
MAINTAINER james.eckersall@1and1.co.uk
ARG DEBIAN_FRONTEND=noninteractive
COPY files /
RUN \
    apt-get update && \
    apt-get install -y python-software-properties software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y php5.6-cli php5.6-fpm php5.6-bcmath php5.6-bz2 php5.6-dba php5.6-imap php5.6-intl php5.6-mcrypt php5.6-soap php5.6-tidy php5.6-common php5.6-curl php5.6-gd php5.6-mysql php5.6-sqlite php5.6-xml php5.6-zip php5.6-gettext php5.6-mbstring && \
    mkdir /tmp/composer/ && \
    cd /tmp/composer && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer && \
    cd / && \
    rm -rf /tmp/composer && \
    apt-get remove -y python-software-properties software-properties-common && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default && \
    sed -i -e 's/^user = www-data$/;user = www-data/g' /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e 's/^group = www-data$/;group = www-data/g' /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e 's/^listen.owner = www-data$/;listen.owner = www-data/g' /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e 's/^listen.group = www-data$/;listen.group = www-data/g' /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/5.6/fpm/php.ini && \
    sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php/5.6/fpm/php.ini && \
    sed -i -e 's/post_max_size = 8M/post_max_size = 50M/g' /etc/php/5.6/fpm/php.ini && \
    sed -i -e 's/fastcgi_param  SERVER_PORT        $server_port;/fastcgi_param  SERVER_PORT        $http_x_forwarded_port;/g' /etc/nginx/fastcgi.conf && \
    sed -i -e 's/fastcgi_param  SERVER_PORT        $server_port;/fastcgi_param  SERVER_PORT        $http_x_forwarded_port;/g' /etc/nginx/fastcgi_params && \
    sed -i -e '/sendfile on;/a\        fastcgi_read_timeout 300\;' /etc/nginx/nginx.conf && \
    mkdir --mode 777 /var/run/php && \
    chmod 755 /hooks /var/www && \
    chmod -R 777 /var/www/html /var/log && \
    sed -i -e 's/index index.html/index index.php index.html/g' /etc/nginx/sites-enabled/site.conf && \
    chmod 666 /etc/nginx/sites-enabled/site.conf /etc/passwd /etc/group
