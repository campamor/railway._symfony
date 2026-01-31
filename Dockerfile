FROM php:8.2-apache

# Apagar todos los MPM y encender solo prefork
RUN a2dismod mpm_event || true \
    && a2dismod mpm_worker || true \
    && a2dismod mpm_prefork || true \
    && a2enmod mpm_prefork

# Activar rewrite y extensiones
RUN a2enmod rewrite \
    && docker-php-ext-install pdo pdo_mysql mysqli

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

CMD ["apache2-foreground"]


