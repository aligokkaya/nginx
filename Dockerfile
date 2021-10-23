FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev -y
RUN apt-get install build-essential -y
RUN apt-get install nano -y

RUN apt-get install -y wget
RUN wget http://nginx.org/download/nginx-1.18.0.tar.gz 
RUN wget https://github.com/arut/nginx-rtmp-module/archive/master.zip 
RUN tar -zxvf nginx-1.18.0.tar.gz 
RUN apt-get install unzip -y
RUN unzip master.zip 
RUN apt-get install gcc -y

RUN cd nginx-1.18.0 \
    && ./configure \
        --add-module=../nginx-rtmp-module-master  \
        --with-http_ssl_module  \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-file-aio \
        --with-ipv6 \
    && make\
    && make install

COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf
COPY ./stat.xsl /usr/local/nginx/html/stat.xsl

EXPOSE 8080
EXPOSE 1935

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

