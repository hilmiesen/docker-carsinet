FROM alpine:3.9
RUN apk --update add --no-cache bash apache2 php7-apache2 php7-curl php7-sqlite3 php7-session php7-json php7-openssl

# configure apache
RUN mkdir -p /run/apache2 && chown -R apache:apache /run/apache2 && \
    sed -i 's#^DocumentRoot ".*#DocumentRoot "/var/www/carsinet"#g' /etc/apache2/httpd.conf && \
	sed -i 's#AllowOverride none#AllowOverride All#' /etc/apache2/httpd.conf && \
    sed -i 's#Require all denied#Require all granted#' /etc/apache2/httpd.conf && \
	sed -i 's#\#LoadModule rewrite_module modules\/mod_rewrite.so#LoadModule rewrite_module modules\/mod_rewrite.so#' /etc/apache2/httpd.conf && \
    sed -i 's#ServerName www.example.com:80#\nServerName localhost:80#' /etc/apache2/httpd.conf && \
	sed -i 's#display_errors = Off#display_errors = On#' /etc/php7/php.ini && \
    sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 100M#' /etc/php7/php.ini && \
    sed -i 's#post_max_size = 8M#post_max_size = 100M#' /etc/php7/php.ini && \
    sed -i 's#session.cookie_httponly =#session.cookie_httponly = true#' /etc/php7/php.ini && \
    sed -i 's#error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT#error_reporting = E_ALL#' /etc/php7/php.ini

ADD https://github.com/hilmiesen/carsinet/archive/master.zip /var/carsinet.zip	

RUN unzip -q /var/carsinet.zip -d /var/www && \
	mv /var/www/carsinet-master /var/www/carsinet && \
	rm /var/carsinet.zip && \
	chown -R apache:apache /var/www/	

COPY entry.sh /entry.sh	
RUN chmod u+x /entry.sh

EXPOSE 80
ENTRYPOINT ["/entry.sh"]