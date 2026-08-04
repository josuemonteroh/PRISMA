FROM php:8.2-apache

RUN a2enmod rewrite

# ---------------------------------------------------------
# Dependencias del sistema necesarias para Oracle Instant Client
# ---------------------------------------------------------
RUN apt-get update \
    && (apt-get install -y libaio1 || apt-get install -y libaio1t64) \
    && apt-get install -y --no-install-recommends \
        unzip \
        wget \
        libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && ( \
        [ -e /lib/x86_64-linux-gnu/libaio.so.1 ] || \
        ln -s "$(find / -name 'libaio.so.1*' 2>/dev/null | head -n 1)" /lib/x86_64-linux-gnu/libaio.so.1 \
    ) \
    && ldconfig

# ---------------------------------------------------------
# Oracle Instant Client (requerido por la extensión oci8)
# Se usan los enlaces "permanentes" de Oracle, que siempre
# apuntan a la última versión disponible (no se vencen).
# ---------------------------------------------------------
WORKDIR /opt/oracle

RUN wget -q https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -O basiclite.zip

RUN wget -q https://download.oracle.com/otn_software/linux/instantclient/instantclient-sdk-linuxx64.zip -O sdk.zip

RUN unzip -q -o basiclite.zip && unzip -q -o sdk.zip && rm -f *.zip

RUN mv instantclient_* instantclient

RUN cd instantclient \
    && ( [ -e libclntsh.so ] || ln -s "$(ls libclntsh.so.* | sort -V | tail -n 1)" libclntsh.so ) \
    && ( [ -e libocci.so ]   || ln -s "$(ls libocci.so.*   | sort -V | tail -n 1)" libocci.so ) \
    && echo "/opt/oracle/instantclient" > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig

ENV LD_LIBRARY_PATH="/opt/oracle/instantclient:${LD_LIBRARY_PATH}"

# ---------------------------------------------------------
# Extensión OCI8 (conexión PHP <-> Oracle)
# ---------------------------------------------------------
RUN echo "instantclient,/opt/oracle/instantclient" | pecl install oci8 \
    && docker-php-ext-enable oci8

WORKDIR /var/www/html
