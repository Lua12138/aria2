FROM ubuntu:16.04 AS builder

RUN apt-get update && \
    apt-get install -y build-essential  libc-ares2 git libxml2-dev libcppunit-dev autoconf automake autotools-dev autopoint libtool libgnutls28-dev nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config && \
    git clone https://github.com/aria2/aria2.git /compile --depth 1

RUN cd /compile && \
    sed -i '443s/16/16386/' src/OptionHandlerFactory.cc && \
    autoreconf -i && \
    ./configure --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt' --enable-shared=no --with-openssl --enable-static ARIA2_STATIC=yes && \
    make -j4 && \
    make install

ADD . /compile/
 
FROM alpine
COPY --from=builder /compile/hello /bin
CMD ["aria2c","--conf-path=/etc/aria2.conf"]
