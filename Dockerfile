# Étape 1 : base PHP avec extensions nécessaires
FROM php:8.2-fpm

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    git unzip zip curl libicu-dev libonig-dev libxml2-dev libzip-dev libpq-dev libjpeg-dev libpng-dev libfreetype6-dev \
    && docker-php-ext-install intl pdo pdo_mysql opcache zip

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier uniquement les fichiers nécessaires à composer
COPY composer.json composer.lock ./

# Empêcher les scripts symfony (évite l’erreur `symfony-cmd not found`)
ENV SYMFONY_SKIP_AUTO_RUN=1

# Installer les dépendances PHP (avant de copier tout le code pour préserver `vendor/`)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copier le reste de l’application
COPY . .

# S'assurer que le dossier `var/` existe
RUN mkdir -p var

# Fixer les permissions
RUN chown -R www-data:www-data var vendor

# Exposer le port utilisé par le serveur PHP interne
EXPOSE 8000

# Démarrer Symfony avec le serveur PHP interne (en mode prod si souhaité)
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
