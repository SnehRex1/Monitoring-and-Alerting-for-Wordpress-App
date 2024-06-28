# Start with the latest Alpine image
FROM alpine:latest

# Set OpenResty version
ENV OPENRESTY_VERSION=1.19.9.1

# Install necessary packages and dependencies
RUN apk add --no-cache \
    wget \
    tar \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    perl \
    postgresql-dev

# Download and extract OpenResty
RUN wget https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
    tar -xzvf openresty-${OPENRESTY_VERSION}.tar.gz && \
    rm openresty-${OPENRESTY_VERSION}.tar.gz && \
    cd openresty-${OPENRESTY_VERSION} && \
    ./configure --prefix=/opt/openresty \
    --with-pcre-jit \
    --with-ipv6 \
    --without-http_redis2_module \
    --with-http_iconv_module \
    --with-http_postgres_module \
    -j8 && \
    make -j8 && \
    make install

# Copy custom Nginx configuration and Lua scripts
COPY nginx.conf /opt/openresty/nginx/conf/nginx.conf
COPY lua-scripts/ /opt/openresty/nginx/lua-scripts/

# Set the command to run OpenResty
CMD ["/opt/openresty/bin/openresty", "-g", "daemon off;"]
