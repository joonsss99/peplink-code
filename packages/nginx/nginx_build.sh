#!/bin/sh

PACKAGE=$1

FETCHEDDIR=${FETCHDIR}/${PACKAGE}

. ./make.conf

abspath=`pwd`

case $PL_BUILD_ARCH in
	ar7100)
		nginx_endian=big
		upload_define="MOUNT_MIPS=1"
		nginx_extra_opts="--without-accept4"
		;;
	powerpc)
		nginx_endian=big
		upload_define="MOUNT_POWERPC=1"
		;;
	*x86*)
		nginx_endian=little
		upload_define="MOUNT_X86=1"
		;;
	arm|arm64)
		case $BUILD_TARGET in
		ipq|apone|aponeax|maxdcs_ipq|ipq64|mtk5g|sfchn)
			nginx_endian=little
			# temporary reuse MIPS option
			upload_define="MOUNT_MIPS=1"
			;;
		*)
			echo "arch $PL_BUILD_ARCH target $BUILD_TARGET not supported"
			exit 1
			;;
		esac
		;;
	ramips)
		nginx_endian=little
		upload_define="MOUNT_MIPS=1"
		;;
	*)
		echo "arch $PL_BUILD_ARCH not supported"
		exit 1
		;;
esac

cd $FETCHEDDIR
if [ ! -f Makefile ] ; then
	ngx_force_have_map_devzero="yes" \
	auto/configure \
		--with-cc=`which $HOST_PREFIX-gcc` \
		--with-cc-opt="-O2 -I$STAGING/usr/include -D$upload_define" \
		--with-ld-opt=-L$STAGING/usr/lib \
		--prefix=/tmp/nginx \
		--sbin-path=/usr/sbin/nginx \
		--conf-path=/etc/nginx/nginx.conf \
		--with-http_ssl_module \
		--with-http_sub_module \
		--without-http-cache \
		--without-http_gzip_module \
		--without-http_split_clients_module \
		--without-http_uwsgi_module \
		--without-http_scgi_module \
		--without-http_memcached_module \
		--without-http_limit_conn_module \
		--without-http_limit_req_module \
		--without-http_empty_gif_module \
		--without-http_browser_module \
		--without-http_upstream_hash_module \
		--without-http_upstream_ip_hash_module \
		--without-http_upstream_least_conn_module \
		--without-http_upstream_keepalive_module \
		--without-http_upstream_zone_module \
		--add-module=../nginx-upload-module \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/lock/nginx.lock \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--with-endianess=$nginx_endian \
		--with-pismo-http-proxy-binddev \
		$nginx_extra_opts \
		--user=root \
		--group=root || exit $?
fi

make $MAKE_OPTS || exit $?
