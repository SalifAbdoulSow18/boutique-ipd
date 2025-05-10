FROM php:8.2-fpm

# Install system packages
RUN apt-get update && apt-get install -y \
    git unzip zip libicu-dev libonig-dev libxml2-dev libzip-dev libpq-dev \
    && docker-php-ext-install intl pdo pdo_mysql opcache zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# ⛔️ Désactive les scripts auto-exécutés de Symfony (évite l'erreur symfony-cmd)
ENV SYMFONY_SKIP_AUTO_RUN=1

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

# Expose port and run
EXPOSE 8000
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
