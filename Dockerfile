# Imagen base con PHP y Apache
FROM php:8.2-apache

# Habilitar mod_rewrite (muy común en frameworks)
RUN a2enmod rewrite

# Instalar extensiones comunes
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Copiar el código al contenedor
COPY . /var/www/html/

# Permisos
RUN chown -R www-data:www-data /var/www/html

# Puerto que usa Railway
EXPOSE 8080

# Cambiar Apache a puerto 8080 (Railway lo requiere)
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-enabled/000-default.conf

# Comando por defecto
CMD ["apache2-foreground"]
