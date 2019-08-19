#!/bin/sh

if [ $# -lt 1 ] ; then
	echo -e "Usage: makedeb.sh <version>\n"
	exit 0
fi


VERSION=$1
ARCH=all
PROG=freedwall
NEWHOME="${PROG}-${VERSION}_${ARCH}"


if [ -d $NEWHOME ] ; then
	rm -rf $NEWHOME
fi

if [ -f ${PROG}-${VERSION}_${ARCH}.deb ] ; then
	rm -f ${PROG}-${VERSION}_${ARCH}.deb
fi


# create tree
mkdir $NEWHOME
mkdir -p $NEWHOME/DEBIAN
mkdir -p $NEWHOME/etc/init.d
mkdir -p $NEWHOME/usr/share/doc/$PROG


cp $PROG/$PROG.conf	$NEWHOME/etc/
cp $PROG/$PROG		$NEWHOME/etc/init.d/
chmod +x $NEWHOME/etc/init.d/$PROG
for f in Changelog COPYING CREDITS README
do
	cp $PROG/$f $NEWHOME/usr/share/doc/$PROG
done


SIZE=$(du -ks $NEWHOME | awk '{print $1}')


# create MD5 sums
cd $NEWHOME
for dir in etc usr 
do
	find $dir -exec md5sum {} \; >> DEBIAN/md5sums 2> /dev/null
done
cd ..

for f in prerm postrm preinst postinst conffiles
do
	cp $PROG/DEBIAN/$f $NEWHOME/DEBIAN/
done


cat << STDIN > $NEWHOME/DEBIAN/control
Package: $PROG
Version: $VERSION
Section: net
Priority: optional
Architecture: all
Essential: no
Depends: libc6, grep, gawk, sed, iptables, coreutils, net-tools, make, util-linux, sysv-rc
Pre-Depends: perl
Installed-Size: $SIZE
Maintainer: Gabriele Pigozzo [gabriele@gabrielepigozzo.net]
Description: iptables rules generator
STDIN

dpkg -b $NEWHOME ${PROG}-${VERSION}_${ARCH}.deb

rm -rf $NEWHOME 

exit 0
