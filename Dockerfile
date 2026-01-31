FROM php:8.2-apache

# 1. Extensiones necesarias
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Configuración de Apache
RUN a2enmod rewrite \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

# 3. Preparar el directorio
WORKDIR /var/www/html
COPY . .
RUN chown -R www-data:www-data /var/www/html

# 4. Configuración del puerto dinámica
# Modificamos el puerto de escucha justo antes de arrancar para que coincida con Railway
# Esto evita tocar archivos internos que causan el error AH00534
CMD sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf && \
    sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf && \
    apache2-foreground
