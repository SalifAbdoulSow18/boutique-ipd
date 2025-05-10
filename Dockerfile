FROM php:8.2.17-cli

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    unzip git zip curl libzip-dev libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip intl opcache

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le dossier de travail
WORKDIR /var/www/html

# Copier les fichiers composer (pour le cache)
COPY composer.json composer.lock ./

# Installer les dépendances (prod) avec cache
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# Copier le reste de l'application
COPY . .

# Redonner les permissions à Symfony pour le cache et les logs
RUN mkdir -p var/cache var/log && \
    chown -R www-data:www-data var

# Exposer le port 8000
EXPOSE 8000

# Lancer le serveur PHP (dev/test uniquement)
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
