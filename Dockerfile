FROM php:8.2.17-cli

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip libzip-dev libicu-dev libxml2-dev libpng-dev libjpeg-dev zlib1g-dev pkg-config \
    && docker-php-ext-install pdo pdo_mysql zip intl opcache


# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Set proper permissions (si ton app les nécessite)
RUN mkdir -p var && chown -R www-data:www-data var

# Start server (pour dev/test, pas pour prod !)
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
