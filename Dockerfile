FROM php:8.2-apache

RUN a2enmod rewrite

# Forzar un único MPM
RUN a2dismod mpm_event || true \
    && a2dismod mpm_worker || true \
    && a2enmod mpm_prefork

# Limpiar duplicados
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load \
    && ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load

# Extensiones PHP
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip && \
    docker-php-ext-install mysqli pdo pdo_mysql zip

# Ajustar Apache al puerto dinámico de Railway
RUN sed -i "s/80/\${PORT}/g" /etc/apache2/ports.conf /etc/apache2/sites-enabled/000-default.conf

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]




