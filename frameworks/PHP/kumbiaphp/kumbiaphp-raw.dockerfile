FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -yqq && apt-get install -yqq software-properties-common > /dev/null
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update -yqq  > /dev/null
RUN apt-get install -yqq nginx git unzip php7.3 php7.3-common php7.3-cli php7.3-fpm php7.3-mysql  > /dev/null

COPY deploy/conf/* /etc/php/7.3/fpm/

ADD ./ /kumbiaphp
WORKDIR /kumbiaphp

RUN git clone -b v1.0.0-rc.2 --single-branch --depth 1 -q https://github.com/KumbiaPHP/KumbiaPHP.git vendor/Kumbia

RUN if [ $(nproc) = 2 ]; then sed -i "s|pm.max_children = 1024|pm.max_children = 512|g" /etc/php/7.3/fpm/php-fpm.conf ; fi;

CMD service php7.3-fpm start && \
    nginx -c /kumbiaphp/deploy/nginx.conf -g "daemon off;"
