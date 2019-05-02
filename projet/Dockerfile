FROM ubuntu

RUN apt update -y && apt upgrade -y  
RUN apt install -y apache2 

VOLUME /var/www/html

ADD index.html /var/www/html

EXPOSE 80

CMD [" /usr/sbin/apache2ctl", "-D", "FOREGROUND"]
