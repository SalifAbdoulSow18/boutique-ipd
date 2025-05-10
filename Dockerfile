FROM php:8.2.17-cli

# Install dependencies
RUN apt-get update && apt-get install -y git unzip libicu-dev libzip-dev libonig-dev zip && \
    docker-php-ext-install intl pdo pdo_mysql zip

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
