FROM hshar/webapp

RUN rm -rf /var/www/html/*

COPY . /var/www/html/

EXPOSE 80
