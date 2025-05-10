# Étape 1 : build PHP avec les extensions nécessaires
FROM php:8.2-cli as build

# Installer les dépendances système et extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev zip libpng-dev libjpeg-dev libonig-dev libxml2-dev libicu-dev libpq-dev libcurl4-openssl-dev \
    && docker-php-ext-install pdo pdo_mysql zip intl opcache

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le dossier de travail
WORKDIR /var/www/html

# Copier les fichiers du projet Symfony
COPY . .

# Installer les dépendances PHP sans les dev
RUN composer install --no-dev --optimize-autoloader

# Étape 2 : runtime (image finale plus légère)
FROM php:8.2-cli

RUN apt-get update && apt-get install -y libzip4 libicu72 libxml2 unzip \
    && docker-php-ext-install pdo pdo_mysql zip intl opcache

# Copier uniquement les fichiers nécessaires depuis l'étape de build
WORKDIR /var/www/html
COPY --from=build /var/www/html /var/www/html

# Exposer le port utilisé par le serveur interne PHP
EXPOSE 8000

# Commande de démarrage du serveur Symfony
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]