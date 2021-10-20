FROM ubuntu:16.04    

RUN apt-get update && \
    apt-get install -y libc-ares2 git libxml2-dev libcppunit-dev autoconf automake autotools-dev autopoint libtool libgnutls28-dev nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config && \
    git clone https://github.com/aria2/aria2.git && \
    cd aria2 && \
    sed -i '443s/16/16386/' src/OptionHandlerFactory.cc && \
    autoreconf -i && \
    ./configure --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt' ARIA2_STATIC=yes && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -rf ./aria2
 
 CMD ["aria2c","--conf-path=/etc/aria2.conf"]
