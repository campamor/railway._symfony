# Imagen base PHP + Apache
FROM php:8.2-apache

# Activar módulos necesarios
RUN a2enmod rewrite

# Instalar extensiones PHP comunes
RUN apt-get update && apt-get install -y libzip-dev zip unzip \
    && docker-php-ext-install mysqli pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar la aplicación al contenedor
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# Configurar Apache para usar el puerto que asigna Railway en runtime
ENV PORT 8080
RUN sed -i "s/80/${PORT}/g" /etc/apache2/ports.conf /etc/apache2/sites-enabled/000-default.conf

# Exponer puerto (solo referencia, Railway maneja el mapping)
EXPOSE 8080

# Arranque de Apache en primer plano
CMD ["apache2-foreground"]
