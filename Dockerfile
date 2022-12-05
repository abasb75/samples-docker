FROM m.docker-registry.ir/php:7.4-apache






RUN apt-get update && apt-get install -y

#RUN docker-php-ext-install mysqli pdo_mysql
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql


RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd



RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-install zip



RUN apt-get install -y  python3.10 pip
RUN pip install numpy==1.22.1
RUN pip install pillow
RUN pip install pydicom
RUN pip install opencv-python

#RUN apt-get install -y python3-tk
#RUN pip install med2image
#RUN pip install scipy

COPY ./dist /var/www/html
#COPY ./build /var/www/html
COPY ./build /var/www/html/v2
COPY ./dicoms /var/www/html/dicoms
COPY ./home /var/www/html/home
COPY ./user /var/www/html/user
COPY ./.htaccess /var/www/html/

#COPY ./ssl/000-default.conf /etc/apache2/sites-available/000-default.conf
#COPY ./ssl/certificate.crt /etc/ssl/certificate.crt
#COPY ./ssl/ca_bundle.crt /etc/ssl/ca_bundle.crt
#COPY ./ssl/private.key /etc/ssl/private.key

RUN chown -R www-data:www-data /var/www #this line after COPY

RUN a2enmod rewrite
#RUN a2enmod ssl






EXPOSE 80
EXPOSE 443
