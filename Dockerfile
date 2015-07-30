FROM php:5.6-fpm
MAINTAINER Alexey Zakhlestin <indeyets@gmail.com>

# OS dependencies
RUN apt-get update && apt-get install -y \
    libicu52 libicu-dev build-essential libssl-dev \
    libgraphicsmagick1-dev

# configuration
RUN (echo 'date.timezone=UTC' > /usr/local/etc/php/php.ini) \
  && (echo 'env[MONGO_PORT_27017_TCP_ADDR] = $MONGO_PORT_27017_TCP_ADDR' >> /usr/local/etc/php-fpm.conf) \
  && (echo 'env[MONGO_PORT_27017_TCP_PORT] = $MONGO_PORT_27017_TCP_PORT' >> /usr/local/etc/php-fpm.conf) \
  && (echo 'env[REDIS_PORT_6379_TCP_ADDR] = $REDIS_PORT_6379_TCP_ADDR' >> /usr/local/etc/php-fpm.conf) \
  && (echo 'env[REDIS_PORT_6379_TCP_PORT] = $REDIS_PORT_6379_TCP_PORT' >> /usr/local/etc/php-fpm.conf)

# bundled extensions
RUN docker-php-ext-install exif gd intl mbstring opcache

# external extensions
RUN pecl channel-discover pear.twig-project.org \
  && pecl install twig/CTwig \
  && (echo extension=twig.so > /usr/local/etc/php/conf.d/twig.ini) \
  && pecl install gmagick-beta \
  && (echo extension=gmagick.so > /usr/local/etc/php/conf.d/gmagick.ini)

RUN (yes '' | pecl install mongo) \
  && (echo extension=mongo.so > /usr/local/etc/php/conf.d/mongo.ini)
