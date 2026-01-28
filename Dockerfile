FROM php:8.2-apache

# Dependencias y extensiones PHP
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Apache escuchando el puerto dinámico de Railway
RUN sed -i 's/Listen 80/Listen ${PORT}/' /etc/apache2/ports.conf \
 && sed -i 's/:80/:${PORT}/' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

# Copiar la app
COPY . .

# Composer
#COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
#RUN composer install --no-dev --optimize-autoloader

# Permisos
RUN chown -R www-data:www-data /var/www/html

EXPOSE ${PORT}

CMD ["apache2-foreground"]

