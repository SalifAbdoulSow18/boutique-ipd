FROM php:8.2.17-fpm

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    unzip git zip curl libzip-dev libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip intl opcache

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le dossier de travail
WORKDIR /var/www/html

# Copier uniquement les fichiers nécessaires pour l'installation des dépendances
COPY composer.json composer.lock symfony.lock ./

# Installer les dépendances (prod)
RUN composer install --no-dev --no-scripts --optimize-autoloader --prefer-dist

# Copier le reste de l'application
COPY . .

# Configurer les permissions
RUN mkdir -p var/cache var/log public \
    && chown -R www-data:www-data var public \
    && chmod -R 755 var public

# Exposer le port 9000 (port par défaut de PHP-FPM)
EXPOSE 9000

# Commande pour PHP-FPM
CMD ["php-fpm"]
