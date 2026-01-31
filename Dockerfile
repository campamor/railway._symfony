FROM php:8.2-apache

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Extensiones PHP típicas
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copiar tu proyecto
COPY . /var/www/html/

# Permisos recomendados
RUN chown -R www-data:www-data /var/www/html

# Exponer el puerto de Apache
EXPOSE 80

# Arrancar Apache
CMD ["apache2-foreground"]



