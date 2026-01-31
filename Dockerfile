# 1. Imagen base oficial de PHP con Apache
FROM php:8.2-apache

# 2. Instalación de dependencias del sistema y extensiones de PHP
# (Incluye pdo_mysql y zip como tenías originalmente)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Habilitar mod_rewrite (vital para frameworks y rutas amigables)
RUN a2enmod rewrite

# 4. Redirigir logs de Apache a la consola de Railway
# Esto hará que los errores aparezcan en la pestaña "Deploy Logs"
RUN ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

# 5. Establecer el directorio de trabajo
WORKDIR /var/www/html

# 6. Copiar los archivos de tu proyecto (incluyendo tu index.php)
COPY . .

# 7. Ajustar permisos para que Apache pueda leer/escribir correctamente
RUN chown -R www-data:www-data /var/www/html

# 8. Comando de arranque
# Este comando es el más importante:
# - Sustituye el puerto 80 por el que Railway asigne ($PORT) en tiempo de ejecución.
# - Luego arranca Apache en primer plano.
CMD ["sh", "-c", "sed -i \"s/Listen 80/Listen ${PORT}/\" /etc/apache2/ports.conf && sed -i \"s/:80/:${PORT}/\" /etc/apache2/sites-available/000-default.conf && apache2-foreground"]
