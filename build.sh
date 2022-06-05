export IP=192.168.15.64
export PORT=1337

dub --compiler=ldc2 --arch=armv7a-unknown-unknown
make && curl ftp://$IP:$PORT/ux0:/ -T ./vita_sample.vpk