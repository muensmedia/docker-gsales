FROM            richarvey/nginx-php-fpm:1.8.2
MAINTAINER      MÜNSMEDIA GmbH - Malte Müns <m.muens@muensmedia.de>

ENV     EMPTY_STRING ""
ENV     PHP_VERSION 7.3
ENV     GSALES_REVISION 1134
ENV     GSALES_HOME /var/www/gsales
ENV     WEBROOT /var/www/gsales
ENV     RUN_SCRIPTS 1

# Install ioncube loader
RUN cd /tmp \
    && wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -qO - | tar xfvz - \
    && mv ioncube/ioncube_loader_lin_${PHP_VERSION}.so /usr/local/lib/php/extensions/ \
    && rm -rf ioncube \
    && echo "zend_extension=/usr/local/lib/php/extensions/ioncube_loader_lin_${PHP_VERSION}.so" > /usr/local/etc/php/conf.d/00_ioncubeloader.ini

# Download g*Sales
RUN mkdir -p ${GSALES_HOME} \\
    && export GSALES_DOWNLOAD_URL=https://www.gsales.de/download/gsales2-rev${GSALES_REVISION}-php${PHP_VERSION/./$EMPTY_STRING}.tar.gz \
    && echo ${GSALES_DOWNLOAD_URL} \
    && wget ${GSALES_DOWNLOAD_URL} -qO - | tar --strip=1 -xzC ${GSALES_HOME}
RUN chown -R nginx:nginx ${GSALES_HOME}

# activate php calendar extension; needed for function easter_date()
RUN docker-php-ext-configure calendar && docker-php-ext-install calendar

# Add scripts
RUN mkdir -p /var/www/html/scripts/
ADD scripts/00_create_missing_folders.sh /var/www/html/scripts/00_create_missing_folders.sh
ADD scripts/01_write_database_config.sh /var/www/html/scripts/01_write_database_config.sh
ADD scripts/02_configure_smtp_settings.sh /var/www/html/scripts/02_configure_smtp_settings.sh
ADD conf/nginx/nginx-site.conf /var/www/html/conf/nginx/nginx-site.conf