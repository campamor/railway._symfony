FROM php:8.2-apache

# Activar rewrite y asegurar solo prefork
RUN a2dismod mpm_event mpm_worker || true \
    && a2enmod mpm_prefork rewrite

# Instalar extensiones PHP necesarias
RUN apt-get update && apt-get install -y libzip-dev zip unzip \
    && docker-php-ext-install mysqli pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar la aplicación
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# Ajuste de puerto en runtime (no build)
ENV APACHE_RUN_PORT=8080
EXPOSE 8080

CMD ["apache2-foreground"]
