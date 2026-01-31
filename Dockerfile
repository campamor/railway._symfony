FROM php:8.2-apache

# 1. Extensiones necesarias
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Configuración de Apache y logs
RUN a2enmod rewrite \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

# 3. Preparar el directorio
WORKDIR /var/www/html
COPY . .
RUN chown -R www-data:www-data /var/www/html

# 4. EL FIX MAESTRO:
# En lugar de editar archivos complejos, creamos una configuración mínima
# que Railway pueda llenar al arrancar.
RUN echo "Listen \${PORT}" > /etc/apache2/ports.conf \
    && printf "<VirtualHost *:\${PORT}>\n\tDocumentRoot /var/www/html\n\t<Directory /var/www/html>\n\t\tAllowOverride All\n\t\tRequire all granted\n\t</Directory>\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

# 5. Comando de ejecución
# Usamos 'exec' para que Apache sea el proceso principal (PID 1)
# Esto evita que el contenedor muera inesperadamente.
CMD ["sh", "-c", "sed -i \"s/\${PORT}/${PORT}/g\" /etc/apache2/ports.conf && sed -i \"s/\${PORT}/${PORT}/g\" /etc/apache2/sites-available/000-default.conf && exec apache2-foreground"]
