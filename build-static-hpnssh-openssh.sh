
#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE
mkdir -p /work/artifact

# HPN_SSH openssh
cd $WORKSPACE
autoreconf -f -i
./configure --prefix=/usr/local/hpnsshmm --sysconfdir=/usr/local/hpnsshmm/etc/ssh --without-pam --with-privsep-path=/usr/local/hpnsshmm/lib/sshd/ --with-pid-dir=/usr/local/hpnsshmm/run --with-mantype=man --with-libedit --with-ldns
sed -i 's@LDFLAGS=@LDFLAGS=-static -no-pie -s @g'  ./Makefile
sed -i 's@LIBEDIT=-ledit@LIBEDIT=-ledit -lncurses -ltinfo@g'  ./Makefile
make
addgroup hpnsshd
adduser --disabled-password hpnsshd -G hpnsshd
make install


cd /usr/local
tar vcJf ./hpnsshmm.tar.xz hpnsshmm

mv ./hpnsshmm.tar.xz /work/artifact/
