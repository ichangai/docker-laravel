FROM php:8.1.17-fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    libonig-dev \
    libpq-dev \
    libicu-dev \
    libxml2-dev \
    libmcrypt-dev \
    libbz2-dev \
    libgmp-dev \
    zlib1g-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libffi-dev \
    libsodium-dev

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd intl soap gmp bz2 opcache sockets sodium

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
COPY . /var/www/html

# Copy configuration files
COPY ./docker/php/local.ini /usr/local/etc/php/conf.d/local.ini

# Change ownership of our applications
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Change permissions of our applications
RUN chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 9000 and start php-fpm server
EXPOSE 8000
CMD ["php-fpm"]




