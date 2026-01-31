FROM php:8.2-apache

# 1. Instalación de dependencias (pdo_mysql y zip)
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Habilitar mod_rewrite
RUN a2enmod rewrite

# 3. Forzar logs a la consola de Railway
RUN ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

# 4. CONFIGURACIÓN DEL PUERTO (El método más seguro)
# En lugar de buscar y reemplazar, borramos el contenido de ports.conf 
# y lo creamos de nuevo para que NO haya duplicados.
RUN echo "Listen \${PORT}" > /etc/apache2/ports.conf

# Modificamos el VirtualHost por defecto de forma segura
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

# 5. Copiar archivos y permisos
COPY . .
RUN chown -R www-data:www-data /var/www/html

# 6. CMD final
# Usamos comillas simples para la variable de shell y evitamos tocar apache2.conf directamente
CMD ["sh", "-c", "sed -i \"s/Listen 80/Listen ${PORT}/g\" /etc/apache2/ports.conf && sed -i \"s/:80/:${PORT}/g\" /etc/apache2/sites-available/000-default.conf && apache2-foreground"]
