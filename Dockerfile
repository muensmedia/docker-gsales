FROM 			richarvey/nginx-php-fpm:1.5.5
MAINTAINER		MÜNSMEDIA GmbH - Malte Müns <m.muens@muensmedia.de>

ENV		GSALES_REVISION 1121
ENV		GSALES_HOME /var/www/gsales
ENV     WEBROOT /var/www/gsales
ENV     RUN_SCRIPTS 1

# Install ioncube loader
RUN cd /tmp \
 	&& wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -qO - | tar xfvz - \
 	&& mv ioncube/ioncube_loader_lin_7.2.so /usr/local/lib/php/extensions/ \
 	&& rm -rf ioncube \
 	&& echo "zend_extension=/usr/local/lib/php/extensions/ioncube_loader_lin_7.2.so" > /usr/local/etc/php/conf.d/00_ioncubeloader.ini

# Download g*Sales
RUN mkdir -p ${GSALES_HOME} \
    && wget https://www.gsales.de/download/gsales2-rev${GSALES_REVISION}-php71.tar.gz -qO - | tar --strip=1 -xzC ${GSALES_HOME} \
    && chown -R nginx:nginx ${GSALES_HOME}

# Add scripts
RUN mkdir -p /var/www/html/scripts/
ADD scripts/00_create_missing_folders.sh /var/www/html/scripts/00_create_missing_folders.sh
ADD scripts/01_write_database_config.sh /var/www/html/scripts/01_write_database_config.sh
ADD scripts/02_configure_smtp_settings.sh /var/www/html/scripts/02_configure_smtp_settings.sh
ADD conf/nginx/nginx-site.conf /var/www/html/conf/nginx/nginx-site.conf