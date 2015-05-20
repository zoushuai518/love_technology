#nginx 编译安装 nginx-http-concat模块 | 淘宝网开发

1.下载 nginx-http-concat模块
git clone git://github.com/alibaba/nginx-http-concat.git

2.查看nginx编译安装情况
/usr/local/nginx/nginx -V
--add-module=../nginx-http-concat 加在最后，如 第3步

3.重新编译安装 Nginx
./configure --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_ssl_module --with-pcre=/usr/local/src/pcre-8.34 --with-zlib=/usr/local/src/zlib-1.2.8 --with-openssl=/usr/local/src/openssl-1.0.1c --add-module=../nginx-http-concat

4.make

5.make install
