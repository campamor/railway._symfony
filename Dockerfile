FROM php:7.4-apache

#instalacion git y actualizacion sistema
RUN apt update && apt install -y git 

WORKDIR /var/www/html

#clonacion de repositorio con aplicacion de symfony
RUN git clone https://github.com/picarenlamina/symfony_blob.git .

#permisos de lectura en apache
RUN chown -R www-data:www-data /var/www/html

#instalacion extensiones mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo 
RUN docker-php-ext-install pdo_mysql

#instalacion de curl y zip
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip
# Docker playgroud requerimiento
ENV COMPOSER_ALLOW_SUPERUSER=1

#descarga e instalacion composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer

#instalacion de extensiones mediante composer configuradas en composer.json
RUN php /usr/bin/composer install 



#RUN  composer require symfony/apache-pack

# Actualizamos fichero de configuracion de apache para que gestione symfony
COPY /apache/apache2.conf /etc/apache2

# Copies your code to the image
COPY /site /var/www/html

# Declarar $PORT en railway con valor 80
EXPOSE $PORT
#CMD [“apache2ctl”, “-D”, “FOREGROUND”]

# Arranque de apache
ENTRYPOINT apache2ctl -D 'FOREGROUND'
