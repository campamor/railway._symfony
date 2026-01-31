FROM php:8.2-apache

RUN a2enmod rewrite

# Desactivar event y activar prefork (necesario para mod_php)
RUN a2dismod mpm_event && a2enmod mpm_prefork

RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip && \
    docker-php-ext-install mysqli pdo pdo_mysql zip

# Ajustar Apache para Railway
RUN sed -i "s/80/\${PORT}/g" /etc/apache2/ports.conf /etc/apache2/sites-enabled/000-default.conf

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]



