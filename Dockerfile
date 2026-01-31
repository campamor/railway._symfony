FROM php:8.2-apache

# 1. Dependencias y extensiones
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Habilitar mod_rewrite
RUN a2enmod rewrite

# 3. FIX: Logs a la consola para ver errores en Railway
RUN ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

# 4. CONFIGURACIÓN DEL PUERTO (Sin romper los MPM)
# Sobreescribimos el puerto en los archivos base antes de arrancar
RUN echo "Listen \${PORT}" > /etc/apache2/ports.conf

# Configuramos el VirtualHost para que apunte al puerto dinámico
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

# 5. Copiar archivos y permisos
COPY . .
RUN chown -R www-data:www-data /var/www/html

# 6. El CMD corregido para evitar el error de MPM
# Usamos apache2-foreground directamente, pero pasando el puerto
CMD ["sh", "-c", "sed -i \"s/Listen 80/Listen ${PORT}/g\" /etc/apache2/ports.conf && sed -i \"s/:80/:${PORT}/g\" /etc/apache2/sites-available/000-default.conf && apache2-foreground"]
