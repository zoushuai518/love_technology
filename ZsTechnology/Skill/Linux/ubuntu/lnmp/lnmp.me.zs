[ Ubuntu 13.04|14.04 编译安装 nmp {zs}]

一.mysql安装    {注：#mysql5.5以上使用cmake代替configure编译，首先需要安装cmake}

1. 安装必备工具：
sudo apt-get install cmake libncurses5-dev  bison g++


2.添加组和用户及安装目录权限
sudo groupadd mysql #添加组
sudo useradd -g mysql mysql -s /bin/false #创建用户mysql并加入到mysql组，不允许mysql用户直接登录系统
sudo mkdir -p /usr/local/mysql #创建MySQL安装目录
sudo mkdir -p /usr/local/mysql/data #创建MySQL安装目录
sudo chown -R mysql:mysql /usr/local/mysql/data #设置MySQL数据库目录权限


3.编译安装mysql
cd /usr/local/src  
sudo wget http://mysql.mirror.kangaroot.net/Downloads/MySQL-5.6/mysql-5.6.12.tar.gz

3.1 解压MySQL
sudo tar -zxvf mysql-5.6.12.tar.gz

3.2 配置编译
sudo cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DSYSCONFDIR=/etc -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DEXTRA_CHARSETS=all -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_DATADIR=/usr/local/mysql/data -DMYSQL_USER=mysql -DWITH_DEBUG=0
sudo make -j4 #-j 数字 表示以多核心运行
sudo make install


4.1配置开机启动
sudo cp ./support-files/my-default.cnf /etc/my.cnf
sudo cp ./support-files/mysql.server  /etc/init.d/mysqld  #把Mysql加入系统启动
sudo chmod 755 /etc/init.d/mysqld
sudo chkconfig mysqld on    #CentOS；如果是ubuntu系统，只需要把启动脚本放到 /etc/init.d/目录下即可通过 linux的 service 服务启动

4.2常用命令软连接
sudo ln -s /usr/local/mysql/bin/mysql /usr/bin
sudo ln -s /usr/local/mysql/bin/mysqladmin /usr/bin

4.3 初始化数据库
sudo /usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --skip-name-resolve --user=mysql

4.4 修改配置文件
sudo vi /etc/my.cnf
文件末尾增加：
#增加默认存储类型和去掉反向解析
default-storage-engine=MyISAM
skip-name-resolve

{
    zs：
    启动 mysql服务：
    /etc/init.d/mysqld start|restart|status|stop
    进入mysql
    mysql -u root -p    {默认 root密码为空}

    ./bin/mysqlbug | grep 'configure' ; cat /usr/local/mysql/bin/mysqlbug | grep CONFIGURE_LINE  查看mysql编译参数

    whereis my.cnf ; locate my.cnf ; mysql --help | grep my.cnf ; mysql --help | grep 'Default options' -A 1 查看mysql配置文件位置

    其他mysql命令行操作:
    ps -ef|grep mysql
}

{
    zs注：
    以下安装内容来自 mysql官方文档,来自 mysql解压后根目录下的 INSTALL-SOURCE 文件
    To install and use a MySQL binary distribution, the basic command
    sequence looks like this:
    shell> groupadd mysql
    shell> useradd -r -g mysql mysql
    shell> cd /usr/local
    shell> tar zxvf /path/to/mysql-VERSION-OS.tar.gz
    shell> ln -s full-path-to-mysql-VERSION-OS mysql
    shell> cd mysql
    shell> chown -R mysql .
    shell> chgrp -R mysql .
    shell> scripts/mysql_install_db --user=mysql
    shell> chown -R root .
    shell> chown -R mysql data
    # Next command is optional
    shell> cp support-files/my-medium.cnf /etc/my.cnf
    shell> bin/mysqld_safe --user=mysql &
    # Next command is optional
    shell> cp support-files/mysql.server /etc/init.d/mysql.server
}



二.PHP编译安装

安装前准备:
sudo apt-get install libxml2 libxml2-dev libxslt-dev
sudo apt-get install libevent-1.4-2 libevent-dev
sudo apt-get install libcurl4-openssl-dev
sudo apt-get install libgd2-xpm libgd2-xpm-dev
sudo apt-get install zlib1g-dev libbz2-dev
sudo apt-get install libmcrypt-dev

tar zxf php-5.5.10.tar.gz
编译php | zs use:
sudo ./configure --prefix=/usr/local/php --mandir=/usr/share/man --infodir=/usr/share/info --sysconfdir=/etc --enable-cli --with-config-file-path=/usr/local/php/etc --with-openssl --with-kerberos --with-zlib --enable-bcmath --with-bz2 --enable-calendar --with-curl --enable-exif --enable-ftp --with-gd --enable-gd-native-ttf --enable-magic-quotes --enable-mbstring --enable-mbregex --enable-json --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-mysql-sock=mysqlnd --with-sqlite --with-pdo-sqlite --enable-pdo --enable-dba --enable-shmop --enable-soap --enable-sockets --enable-wddx --enable-fpm --with-mhash --with-mcrypt=/usr/local/libmcrypt --with-iconv --with-xsl --enable-zend-multibyte --enable-zip --with-pcre-regex --enable-dom --enable-gd-native-ttf --enable-posix --enable-fileinfo --enable-sysvmsg --enable-sysvsem --enable-sysvshm --with-libxml --with-xmlrpc --enable-xml --enable-xmlwriter --enable-xmlreader --enable-maintainer-zts
{
    zs注:仅供参考
    更多选项...
    ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --enable-sysvsem --enable-sockets --enable-pcntl --enable-mbstring --enable-mysqlnd --enable-opcache --enable-shmop  --enable-zip --with-mcrypt=/usr/local/libmcrypt/ --with-zlib=/usr/local/zlib/ --with-curl=/usr/local/curl/ --with-pcre-dir=/usr/local/pcre/ --with-t1lib=/usr/local/tlib/ --with-pdo-mysql=/usr/ --with-fpm-user=www --with-fpm-group=www

    zs use 2:
    [
        --enable-debug开启调试,可以配合gdb使用; --enable-maintainer-zts开启线程安全(php v>5.*.*)

        注意：
        1、如果你的php版本是php5.6或者更高的版本，phpdbg已经集成在php的代码包中，无需单独下载了。
        2、编译参数中记得要加 –enable-phpdbg。
        3、编译时参数，–with-readline 可以选择性添加。如果不添加，phpdbg的history等功能无法使用。
    ]
    ./configure --prefix=/usr/local/php5.5 --mandir=/usr/share/man --infodir=/usr/share/info --sysconfdir=/etc --enable-cli --with-config-file-path=/usr/local/php5.5/etc --with-openssl --with-kerberos --with-zlib --with-bz2 --enable-bcmath --enable-calendar --with-curl --enable-exif --enable-ftp --with-gd --enable-magic-quotes --enable-mbstring --enable-mbregex --enable-json --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-mysql-sock=mysqlnd --with-sqlite --with-pdo-sqlite --enable-pdo --enable-dba --enable-shmop --enable-soap --enable-sockets --enable-wddx --enable-fpm --with-mhash --with-mcrypt=/usr/local/libmcrypt --with-iconv --with-xsl --enable-zend-multibyte --enable-zip --with-pcre-regex --enable-dom --enable-gd-native-ttf --enable-posix --enable-fileinfo --enable-sysvmsg --enable-sysvsem --enable-sysvshm --with-libxml --with-xmlrpc --enable-xml --enable-xmlwriter --enable-xmlreader --enable-debug --enable-maintainer-zts --enable-phpdbg --with-readline
}

sudo make -j 4
sudo make install

安装完成后:
sudo cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm #因为php5.3开始自带fpm，使用自带的管理脚本
sudo chmod +x /etc/init.d/php-fpm
sudo ln -sf /usr/local/php/bin/php /usr/local/bin/
sudo cp /etc/php-fpm.conf.default /etc/php-fpm.conf
sudo cp php.ini-development /usr/local/php/etc/php.ini

{
    #添加www用户，nginx和FastCGI用
    添加执行组和用户，如果添加过，则不需要
    sudo groupadd www 
    sudo useradd -g www www -s /bin/false
}

{
    修改fpm配置
    sudo vi /etc/php-fpm.conf
    将user和group的值改为www,www
    sudo service php-fpm start
    这样php-fpm启动成功，nginx可以fastcgi解析php
    #==
    查看php-fpm是否启动,nginx加载通过 9000端口:sudo netstat -lnp | grep :9000
    tcp        0      0 127.0.0.1:9000          0.0.0.0:*               LISTEN      3730/php-fpm.conf)
    #==
    修改完php.ini之后，重启 fastcgi;重启nginx不会生效
    service php-fpm restart
    即可
}


zs ext:
{
    linux下nginx多版本php共存

    概述:Nginx是通过PHP-FastCGI与PHP交互的。而PHP-FastCGI运行后会通过文件、或本地端口两种方式进行监听，在Nginx中配置相应的FastCGI监听端口或文件即实现Nginx请求对PHP的解释

    实现:既然PHP-FastCGI是监听端口和文件的，那就可以让不同版本的PHP-FastCGI同时运行，监听不同的端口或文件，Nginx中根据需求配置调用不同的PHP-FastCGI端口或文件，即可实现不同版本PHP共存了

    安装配置:
    ......

    zs注：
    以下编译方式仅供参考:
    注意：--prefix  --sysconfdir  --With-config-file-path 这三个配置路径
    1.编译安装成功之后注意修改 php-fpm.conf监听的端口号
    2.php-fpm启动脚本不要重名   |是否可以重名 待验证
    3.nginx配置文件中fastcgi_pass  127.0.0.1:9001 监听的端口号和php-fpm.conf中的一致即使加载对应版本的php
    [./configure --help]

    php5.6  |已经验证
    sudo ./configure --prefix=/usr/local/php5.6 --mandir=/usr/share/man --infodir=/usr/share/info --sysconfdir=/usr/local/php5.6/etc --enable-cli --with-config-file-path=/usr/local/php5.6/etc --with-openssl --with-kerberos --with-zlib --enable-bcmath --with-bz2 --enable-calendar --with-curl --enable-exif --enable-ftp --with-gd --enable-gd-native-ttf --enable-magic-quotes --enable-mbstring --enable-mbregex --enable-json --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-mysql-sock=mysqlnd --with-sqlite --with-pdo-sqlite --enable-pdo --enable-dba --enable-shmop --enable-soap --enable-sockets --enable-wddx --enable-fpm --with-mhash --with-mcrypt=/usr/local/libmcrypt --with-iconv --with-xsl --enable-zend-multibyte --enable-zip --with-pcre-regex --enable-dom --enable-gd-native-ttf --enable-posix --enable-fileinfo --enable-sysvmsg --enable-sysvsem --enable-sysvshm --with-libxml --with-xmlrpc --enable-xml --enable-xmlwriter --enable-xmlreader --enable-maintainer-zts
    sudo make
    make test
    sudo make install

    成功之后执行:
    sudo ln -s -f /usr/local/php5.6/bin/phar.phar /usr/local/php5.6/bin/phar
    sudo cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm5.6
    sudo chmod +x /etc/init.d/php-fpm5.6
    #zs注: 执行上两行之后; 可以使用 service启动服务
    sudo ln -sf /usr/local/php5.6/bin/php /usr/local/bin/php5.6
    sudo cp /etc/php-fpm.conf.default /usr/local/php5.6/etc/php-fpm.conf
    sudo cp php.ini-development /usr/local/php5.6/etc/php.ini

    配置:
    1.php-fpm配置
    {
        #添加www用户，nginx和FastCGI用
        添加执行组和用户，如果添加过，则不需要
        sudo groupadd www
        sudo useradd -g www www -s /bin/false
    }
    vim /usr/local/php5.6/etc/php-fpm.conf
    listen = 127.0.0.1:9001
    user = www
    group = www

    启动服务:
    sudo service php-fpm5.6 start

    2.php.ini配置
    ......

    3.nginx配置
    {
        location ~ \.php$ {
            root   $web_root;
            #fastcgi_pass   127.0.0.1:9000;
            fastcgi_pass   127.0.0.1:9001;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }
    }

    test:
    sudo netstat -lnp|grep 9000
    sudo netstat -lnp|grep 9001
    ps -ef |grep 9001
    php5.6 -m
    #zs注: php 9000端口 & 9001端口 共存

}


phpng(php7-dev)编译安装, 仅供参考(2015-06-23):
{
    http://wiki.php.net/phpng

    #from 官网
    cd php-src
    ./buildconf
    ./configure \
    --prefix=$HOME/tmp/usr \
    --with-config-file-path=$HOME/tmp/usr/etc \
    --enable-mbstring \
    --enable-zip \
    --enable-bcmath \
    --enable-pcntl \
    --enable-ftp \
    --enable-exif \
    --enable-calendar \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-wddx \
    --with-curl \
    --with-mcrypt \
    --with-iconv \
    --with-gmp \
    --with-pspell \
    --with-gd \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    --with-zlib-dir=/usr \
    --with-xpm-dir=/usr \
    --with-freetype-dir=/usr \
    --with-t1lib=/usr \
    --enable-gd-native-ttf \
    --enable-gd-jis-conv \
    --with-openssl \
    --with-mysql=/usr \
    --with-pdo-mysql=/usr \
    --with-gettext=/usr \
    --with-zlib=/usr \
    --with-bz2=/usr \
    --with-recode=/usr \
    --with-mysqli=/usr/bin/mysql_config


    #from github
    ./configure \
    --prefix="/usr/local/opt/phpng" \
    --with-config-file-path="/usr/local/etc/phpng" \
    --enable-mbstring \
    --enable-zip \
    --enable-bcmath \
    --enable-pcntl \
    --enable-ftp \
    --enable-exif \
    --enable-calendar \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-wddx \
    --with-curl \
    --with-iconv \
    --with-gmp \
    --with-gd \
    --with-jpeg-dir=`brew --prefix gd` \
    --with-png-dir=`brew --prefix gd` \
    --with-freetype-dir=`brew --prefix freetype` \
    --with-t1lib=`brew --prefix t1lib` \
    --enable-gd-native-ttf \
    --enable-gd-jis-conv \
    --with-openssl \
    --with-mysql=`brew --prefix mariadb` \
    --with-pdo-mysql=`brew --prefix mariadb` \
    --with-gettext=`brew --prefix gettext` \
    --with-zlib=`brew --prefix zlib` \
    --with-bz2 \
    --with-mysqli=`brew --prefix`/bin/mysql_config \
    --with-mcrypt=`brew --prefix mcrypt`


    #from network
    #zs use; 2015-07-01
    ./configure
    --prefix=/usr/local/php7 \                              [PHP7安装的根目录]
    --exec-prefix=/usr/local/php7 \
    --bindir=/usr/local/php7/bin \
    --sbindir=/usr/local/php7/sbin \
    --includedir=/usr/local/php7/include \
    --libdir=/usr/local/php7/lib/php \
    --mandir=/usr/local/php7/php/man \
    --with-config-file-path=/usr/local/php7/etc \           [PHP7的配置目录]
    --with-mysql-sock=/var/run/mysql/mysql.sock \           [PHP7的Unix socket通信文件]
    --with-mcrypt=/usr/include \
    --with-mhash \
    --with-openssl \
    --with-mysql=shared,mysqlnd \                           [PHP7依赖mysql库]
    --with-mysqli=shared,mysqlnd \                          [PHP7依赖mysql库]
    --with-pdo-mysql=shared,mysqlnd \                       [PHP7依赖mysql库]
    --with-gd \
    --with-iconv \
    --with-zlib \
    --enable-zip \
    --enable-inline-optimization \
    --disable-debug \
    --disable-rpath \
    --enable-shared \
    --enable-xml \
    --enable-bcmath \
    --enable-shmop \
    --enable-sysvsem \
    --enable-mbregex \
    --enable-mbstring \
    --enable-ftp \
    --enable-gd-native-ttf \
    --enable-pcntl \
    --enable-sockets \
    --with-xmlrpc \
    --enable-soap \
    --without-pear \
    --with-gettext \
    --enable-session \                                      [允许php会话session]
    --with-curl \                                           [允许curl扩展]
    --with-jpeg-dir \
    --with-freetype-dir \
    --enable-opcache \                                      [使用opcache缓存]
    --enable-fpm \
    --enable-fastcgi \
    --with-fpm-user=nginx \                                 [php-fpm的用户]
    --with-fpm-group=nginx \                                [php-fpm的用户组]
    --without-gdbm \
    --disable-fileinfo


    #zs install record
    {
        #git clone git@github.com:php/php-src.git
        unzip php-src-master.zip
        cd php-src-master

        #构建configure编译配置脚本
        #./buildconf --force
        ./buildconf


        #仅作为参考
        ./configure --prefix=/usr/local/phpng --sysconfdir=/usr/local/phpng/etc --with-config-file-path=/usr/local/phpng/etc --enable-mbstring --enable-zip --enable-bcmath --enable-pcntl --enable-ftp --enable-exif --enable-calendar --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --with-curl --with-mcrypt --with-iconv --with-gmp --with-pspell --with-gd --with-jpeg-dir=/usr --with-png-dir=/usr --with-zlib-dir=/usr --with-xpm-dir=/usr --with-freetype-dir=/usr --with-t1lib --enable-gd-native-ttf --enable-gd-jis-conv --with-openssl --with-mysql=mysqlnd --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd --with-gettext --with-zlib --with-bz2 --with-recode

        #zs use
        ./configure --prefix=/usr/local/php7 --exec-prefix=/usr/local/php7 --bindir=/usr/local/php7/bin --sbindir=/usr/local/php7/sbin --includedir=/usr/local/php7/include --libdir=/usr/local/php7/lib/php --mandir=/usr/local/php7/php/man --with-config-file-path=/usr/local/php7/etc --with-mysql-sock=/var/run/mysql/mysql.sock --with-mcrypt=/usr/include --with-mhash --with-openssl --with-mysql=shared,mysqlnd --with-mysqli=shared,mysqlnd --with-pdo-mysql=shared,mysqlnd --with-gd --with-iconv --with-zlib --enable-zip --enable-inline-optimization --disable-debug --disable-rpath --enable-shared --enable-xml --enable-bcmath --enable-shmop --enable-sysvsem --enable-mbregex --enable-mbstring --enable-ftp --enable-gd-native-ttf --enable-pcntl --enable-sockets --with-xmlrpc --enable-soap --without-pear --with-gettext --enable-session --with-curl --with-jpeg-dir --with-freetype-dir --enable-opcache --enable-fpm --enable-fastcgi --with-fpm-user=www --with-fpm-group=www --without-gdbm --disable-fileinfo

        make test
        sudo make clean && sudo make && sudo make install

        成功之后执行:
        sudo ln -s -f phar.phar /usr/local/php7/bin/phar    #phar
        sudo cp php.ini-production /usr/local/php7/etc/php.ini      #php.ini配置文件
        sudo cp /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf       #php-fpm主配置
        sudo cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf    #php-fpm扩展配置

        sudo cp ./sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm7      #php-fpm启动脚本
        sudo chmod +x /etc/init.d/php-fpm7
        #zs注: 执行上两行之后; 可以使用 service启动服务

        #使php7命令全局可用
        sudo ln -sf /usr/local/php7/bin/php /usr/local/bin/php7
        #将php编译生成的bin目录添加到当前Linux系统的环境变量中
        echo -e '\nexport PATH=/usr/local/php7/bin:/usr/local/php7/sbin:$PATH\n' >> /etc/profile && source /etc/profile

        配置:
        1.php-fpm配置
        {
            #添加www用户，nginx和FastCGI用
            添加执行组和用户，如果添加过，则不需要
            sudo groupadd www
            sudo useradd -g www www -s /bin/false
        }
        vim /usr/local/php7/etc/php-fpm.conf
        ######设置错误日志的路径
        ; error_log = /var/log/php-fpm/error.log
        error_log = /php-fpm-error.log
        ######引入www.conf文件中的配置
        include=/usr/local/php7/etc/php-fpm.d/*.conf

        vim /usr/local/php7/etc/php-fpm.d/www.conf
        ######设置用户和用户组
        user = www
        group = www
        ######根据nginx.conf中的配置fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;设置PHP监听
        listen = 127.0.0.1:9001   #####不建议使用
        ; listen = /var/run/php-fpm/php-fpm.sock
        ######开启慢日志
        slowlog = /var/log/php-fpm/$pool-slow.log
        request_slowlog_timeout = 10s
        ######设置php的session目录（所属用户和用户组都是nginx）
        php_value[session.save_handler] = files
        php_value[session.save_path] = /var/lib/php/session

        启动服务:
        sudo service php-fpm7 start

        2.php.ini配置
        ......

        3.nginx配置
        {
            location ~ \.php$ {
                root   $web_root;
                fastcgi_pass   127.0.0.1:9001;
                fastcgi_index  index.php;
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include        fastcgi_params;
            }
        }

        test:
        sudo netstat -lnp|grep 9001
        ps -ef |grep php-fpm
        php7 -m
        #zs注: php 9000端口 & 9001端口 共存

        查看是否安装成功
        php7 -v

        查看编译参数:
        php7 -i|grep configure

        编译过程可遇见的错误:
        configure: error: Please reinstall the BZip2 distribution
        sudo apt-get install libbz2-dev

        If configure fails try --with-vpx-dir=<DIR>
        configure: error: jpeglib.h not found.
        sudo apt-get install libjpeg-dev

        configure: error: xpm.h not found.
        sudo apt-get install libxpm-dev

        configure: error: Unable to locate gmp.h
        sudo apt-get install libgmp-dev -y
        locate gmp.h
        sudo ln -s /usr/include/linux/igmp.h /usr/include/gmp.h
        || --with-gmp=/usr/include/linux

        configure: error: Cannot find pspell
        sudo apt-get install libpspell-dev

        configure: error: Can not find recode.h anywhere under yes /usr/local /usr /opt.
        #locate recode | grep include
        sudo apt-get install librecode-dev

        zs备注:
        ubuntu 下的依赖包都是以 lib*开头

    }
}


安装 php 扩展:
{
        install memcache:
        {
            下载 memcache-2.2.7.tgz
            tar zxf memcache-2.2.7.tgz
            cd memcache-2.2.7
            /usr/local/php/bin/phpize   #php安装目录
            #/usr/local/php5.6/bin/phpize
            sudo ./configure --with-php-config=/usr/local/php/bin/php-config --enable-memcache
            #sudo ./configure --with-php-config=/usr/local/php5.6/bin/php-config --enable-memcache
            sudo make
            sudo make install
            #=
            weiyan@weiyan-PC:~/lnmp/memcache-2.2.7$ sudo make install
            Installing shared extensions:     /usr/local/php/lib/php/extensions/no-debug-zts-20121212/
            #Installing shared extensions:     /usr/local/php/lib/php/extensions/no-debug-zts-20131226/
            #= 打开 php.ini
            ;zs-config memcache
            extension_dir = "/usr/local/php/lib/php/extensions/no-debug-zts-20121212/"
            ;extension_dir = "/usr/local/php5.6/lib/php/extensions/no-debug-zts-20131226/"
            extension=memcache.so
            #=重启 phpfast-cgi  |php-fpm
            sudo service php-fpm restart
            #sudo service php-fpm5.6 restart
            #=即可
        }

        install memcached:
        {
            1. install libmemcached:
            wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
            tar zxf libmemcached-1.0.18.tar.gz
            cd libmemcached-1.0.18
            ./configure --prefix=/usr/local/libmemcached --with-memcached
            make
            sudo make install


            2. install php ext memcached:
            wget http://pecl.php.net/get/memcached-2.2.0.tgz
            tar zxf  memcached-2.2.0.tgz
            cd memcached-2.2.0
            /usr/local/php5.5/bin/phpize
            //sudo ./configure --enable-memcached --with-php-config=/usr/local/php5.5/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached
            sudo ./configure --enable-memcached --with-php-config=/usr/local/php5.5/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached --disable-memcached-sasl
            sudo make
            sudo make install

            #= 打开 php.ini, /usr/local/php5.5/etc/php.ini
            ;zs-config memcache
            extension_dir = "/usr/local/php5.5/lib/php/extensions/no-debug-zts-20121212/"
            extension=memcached.so
            #=重启 phpfast-cgi  |php-fpm
            sudo service php-fpm restart

            zs备注:
            php memcached扩展 依赖libmemcached
            http://php.net/manual/zh/memcached.installation.php
        }

        install redis:
        {
            下载 phpredis.tgz
            tar zxf phpredis.tgz
            cd phpredis
            /usr/local/php5.5/bin/phpize   #php安装目录
            sudo ./configure --with-php-config=/usr/local/php5.5/bin/php-config
            sudo make
            sudo make install
            #=
            Installing shared extensions:     /usr/local/php5.5/lib/php/extensions/no-debug-zts-20121212/
            #= 打开 php.ini
            ;zs-config redis
            extension_dir = "/usr/local/php5.5/lib/php/extensions/no-debug-zts-20121212/"
            extension=redis.so
            #=重启 phpfast-cgi  |php-fpm
            sudo service php-fpm restart
        }

        install Xdebug:
        {
            cd xdebug-2.2.x
            /usr/local/php/bin/phpize
            ./configure --enable-xdebug --with-php-config=/usr/local/php/bin/php-config
            make
            sudo cp modules/xdebug.so /usr/local/php/lib/php/extensions/no-debug-zts-20121212/
            sudo service php-fpm restart
        }

        install pcntl:
        {
            http://cn2.php.net/manual/zh/pcntl.installation.php
        }
}



{
    zs: 来自 CentOS仅供参考 
    修改环境变量，让php可执行文件能像linux命令一样
    vim /etc/profile
    在最低端加上
    PATH=/usr/local/php/bin:$PATH
    PATH=/usr/local/php/sbin:$PATH
    source /etc/profile 使修改立即生效
    --
    设置成功后用
    php --help
    php -v
    php -m
    php -i |grep configure; php -i |grep "configure"    #查看php编译参数
    php -i | grep "php.ini" #查看php.ini文件的路径
    ===
    把 php-fpm加入系统服务:
    chkconfig --add php-fpm   #CentOS；如果是ubuntu系统，只需要把启动脚本放到 /etc/init.d/目录下即可通过linux的service服务启动
    service php-fpm {start|stop|force-quit|restart|reload|status}
}



三.nginx编译安装

1.安装必要环境：
apt-get install build-essential
apt-get install libtool

2.安装PCRE库
ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/ 下载最新的 PCRE 源码包，使用下面命令下载编译和安装 PCRE 包：

cd /usr/local/src
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.34.tar.gz 
tar -zxvf pcre-8.34.tar.gz
cd pcre-8.34
./configure
make
make install

3.安装zlib库
http://zlib.net/zlib-1.2.8.tar.gz 下载最新的 zlib 源码包，使用下面命令下载编译和安装 zlib包：
cd /usr/local/src
wget http://zlib.net/zlib-1.2.8.tar.gz
tar -zxvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure
make
make install
{
    zs:
    root@weiyan-ubuntu:/home/weiyan/zs/zlib-1.2.8# make install
    cp libz.a /usr/local/lib
    chmod 644 /usr/local/lib/libz.a
    cp libz.so.1.2.8 /usr/local/lib
    chmod 755 /usr/local/lib/libz.so.1.2.8
    cp zlib.3 /usr/local/share/man/man3
    chmod 644 /usr/local/share/man/man3/zlib.3
    cp zlib.pc /usr/local/lib/pkgconfig
    chmod 644 /usr/local/lib/pkgconfig/zlib.pc
    cp zlib.h zconf.h /usr/local/include
    chmod 644 /usr/local/include/zlib.h /usr/local/include/zconf.h
    root@weiyan-ubuntu:/home/weiyan/zs/zlib-1.2.8# cp libz.a /usr/local/lib
    root@weiyan-ubuntu:/home/weiyan/zs/zlib-1.2.8# chmod 644 /usr/local/lib/libz.a
    root@weiyan-ubuntu:/home/weiyan/zs/zlib-1.2.8# cp libz.so.1.2.8 /usr/local/lib
    root@weiyan-ubuntu:/home/weiyan/zs/zlib-1.2.8# chmod 755 /usr/local/lib/libz.so.1.2.8
    root@weiyan-ubuntu:/home/weiyan/zs/zlib-1.2.8# cp zlib.3 /usr/local/share/man/man3 && chmod 644 /usr/local/share/man/man3/zlib.3
    root@weiyan-ubuntu:/home/weiyan/zs/zlib-1.2.8# cp zlib.pc /usr/local/lib/pkgconfig && chmod 644 /usr/local/lib/pkgconfig/zlib.pc
    root@weiyan-ubuntu:/home/weiyan/zs/zlib-1.2.8# cp zlib.h zconf.h /usr/local/include && chmod 644 /usr/local/include/zlib.h /usr/local/include/zconf.h
    root@weiyan-ubuntu:/home/weiyan/zs/zlib-1.2.8# 
}

4.安装ssl（某些vps默认没装ssl)
cd /usr/local/src
wget http://www.openssl.org/source/openssl-1.0.1c.tar.gz
tar -zxvf openssl-1.0.1c.tar.gz

5.安装nginx
Nginx 一般有两个版本，分别是稳定版和开发版，您可以根据您的目的来选择这两个版本的其中一个，下面是把 Nginx 安装到 /usr/local/nginx 目录下的详细步骤

cd /usr/local/src
wget http://nginx.org/download/nginx-1.4.2.tar.gz
tar -zxvf nginx-1.4.2.tar.gz
cd nginx-1.4.2

./configure --sbin-path=/usr/local/nginx/nginx \
--conf-path=/usr/local/nginx/nginx.conf \
--pid-path=/usr/local/nginx/nginx.pid \
--with-http_ssl_module \
--with-pcre=/usr/local/src/pcre-8.34 \
--with-zlib=/usr/local/src/zlib-1.2.8 \
--with-openssl=/usr/local/src/openssl-1.0.1c
{
    zs:
    ./configure --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_ssl_module --with-pcre=/home/weiyan/zs/pcre-8.34 --with-zlib=/home/weiyan/zs/zlib-1.2.8 --with-openssl=/home/weiyan/zs/openssl-1.0.1c
}

make
make install

{
    zs:
    执行下面的命令;拷贝/创建目录
    root@weiyan-ubuntu:/home/weiyan/zs/nginx-1.4.1# make install
    make -f objs/Makefile install
    make[1]: Entering directory `/home/weiyan/zs/nginx-1.4.1'
    test -d '/usr/local/nginx' || mkdir -p '/usr/local/nginx'
    test -d '/usr/local/nginx'      || mkdir -p '/usr/local/nginx'
    test ! -f '/usr/local/nginx/nginx'      || mv '/usr/local/nginx/nginx'          '/usr/local/nginx/nginx.old'
    cp objs/nginx '/usr/local/nginx/nginx'
    test -d '/usr/local/nginx'      || mkdir -p '/usr/local/nginx'
    cp conf/koi-win '/usr/local/nginx'
    cp conf/koi-utf '/usr/local/nginx'
    cp conf/win-utf '/usr/local/nginx'
    test -f '/usr/local/nginx/mime.types'           || cp conf/mime.types '/usr/local/nginx'
    cp conf/mime.types '/usr/local/nginx/mime.types.default'
    test -f '/usr/local/nginx/fastcgi_params'           || cp conf/fastcgi_params '/usr/local/nginx'
    cp conf/fastcgi_params      '/usr/local/nginx/fastcgi_params.default'
    test -f '/usr/local/nginx/fastcgi.conf'         || cp conf/fastcgi.conf '/usr/local/nginx'
    cp conf/fastcgi.conf '/usr/local/nginx/fastcgi.conf.default'
    test -f '/usr/local/nginx/uwsgi_params'         || cp conf/uwsgi_params '/usr/local/nginx'
    cp conf/uwsgi_params        '/usr/local/nginx/uwsgi_params.default'
    test -f '/usr/local/nginx/scgi_params'      || cp conf/scgi_params '/usr/local/nginx'
    cp conf/scgi_params         '/usr/local/nginx/scgi_params.default'
    test -f '/usr/local/nginx/nginx.conf'           || cp conf/nginx.conf '/usr/local/nginx/nginx.conf'
    cp conf/nginx.conf '/usr/local/nginx/nginx.conf.default'
    test -d '/usr/local/nginx'      || mkdir -p '/usr/local/nginx'
    test -d '/usr/local/nginx/logs' ||      mkdir -p '/usr/local/nginx/logs'
    test -d '/usr/local/nginx/html'         || cp -R html '/usr/local/nginx'
    test -d '/usr/local/nginx/logs' ||      mkdir -p '/usr/local/nginx/logs'
    make[1]: Leaving directory `/home/weiyan/zs/nginx-1.4.1'
}

--with-pcre=/usr/src/pcre-8.34 指的是pcre-8.34 的源码路径。
--with-zlib=/usr/src/zlib-1.2.7 指的是zlib-1.2.7 的源码路径。

安装成功后 /usr/local/nginx 目录下如下

fastcgi.conf            koi-win             nginx.conf.default
fastcgi.conf.default    logs                scgi_params
fastcgi_params          mime.types          scgi_params.default
fastcgi_params.default  mime.types.default  uwsgi_params
html                    nginx               uwsgi_params.default
koi-utf                 nginx.conf          win-utf

6.启动
确保系统的 80 端口没被其他程序占用，运行/usr/local/nginx/nginx 命令来启动 Nginx，
netstat -ano|grep 80
如果查不到结果后执行，有结果则忽略此步骤（ubuntu下必须用sudo启动，不然只能在前台运行）
sudo /usr/local/nginx/nginx

{
    zs:
    {
        sudo /usr/local/nginx//nginx    (启动)
        /usr/local/nginx/nginx -s stop (停止)
        /usr/local/nginx/nginx -s reload (重启)
        /usr/local/nginx/nginx -v[V] (查看版本)

        /usr/local/nginx/nginx -V  查看nginx编译参数
    }

    为nginx提供启动脚本
    vim /etc/init.d/nginx    {zs注：/etc/init.d/nginx文件,则创建}
}

{
    zs注：
    （原文参考：

    http://wiki.codemongers.com/NginxInstallOptions ）
    configure 脚本确定系统所具有一些特性，特别是 nginx 用来处理连接的方法。然后，它创建 Makefile 文件。

    configure 支持下面的选项：

    1）目录属性

    --prefix=<path> - Nginx安装路径。如果没有指定，默认为 /usr/local/nginx。

    --sbin-path=<path> - Nginx可执行文件安装路径。只能安装时指定，如果没有指定，默认为<prefix>/sbin/nginx。

    --conf-path=<path> - 在没有给定-c选项下默认的nginx.conf的路径。如果没有指定，默认为<prefix>/conf/nginx.conf。

    --pid-path=<path> - 在nginx.conf中没有指定pid指令的情况下，默认的nginx.pid的路径。如果没有指定，默认为 <prefix>/logs/nginx.pid。

    --lock-path=<path> - nginx.lock文件的路径，默认为<prefix>/logs/nginx.lock

    --error-log-path=<path> - 在nginx.conf中没有指定error_log指令的情况下，默认的错误日志的路径。如果没有指定，默认为 <prefix>/logs/error.log。

    --http-log-path=<path> - 在nginx.conf中没有指定access_log指令的情况下，默认的访问日志的路径。如果没有指定，默认为 <prefix>/logs/access.log。

    --user=<user> - 在nginx.conf中没有指定user指令的情况下，默认的nginx使用的用户。如果没有指定，默认为 nobody。

    --group=<group> - 在nginx.conf中没有指定user指令的情况下，默认的nginx使用的组。如果没有指定，默认为 nobody。

    --builddir=DIR - 指定编译的目录

    2）模块

    --with-rtsig_module - 启用 rtsig 模块

    --with-select_module --without-select_module -允许或不允许开启SELECT模式，如果 configure 没有找到更合适的模式，比如：kqueue(sun os),epoll (linux kenel 2.6+), rtsig(实时信号)或者/dev/poll(一种类似select的模式，底层实现与SELECT基本相 同，都是采用轮训方法) SELECT模式将是默认安装模式

    --with-poll_module --without-poll_module - Whether or not to enable the poll module. This module is enabled by default if a more suitable method such as kqueue, epoll, rtsig or /dev/poll is not discovered by configure.

    --with-http_ssl_module -开启HTTP SSL模块，使NGINX可以支持HTTPS请求。这个模块需要已经安装了OPENSSL，在DEBIAN上是libssl

    --with-http_realip_module - 启用 ngx_http_realip_module

    --with-http_addition_module - 启用 ngx_http_addition_module

    --with-http_sub_module - 启用 ngx_http_sub_module

    --with-http_dav_module - 启用 ngx_http_dav_module

    --with-http_flv_module - 启用 ngx_http_flv_module

    --with-http_stub_status_module - 启用 "server status" 页

    --without-http_charset_module - 禁用 ngx_http_charset_module

    --without-http_gzip_module - 禁用 ngx_http_gzip_module. 如果启用，需要 zlib 。

    --without-http_ssi_module - 禁用 ngx_http_ssi_module

    --without-http_userid_module - 禁用 ngx_http_userid_module

    --without-http_access_module - 禁用 ngx_http_access_module

    --without-http_auth_basic_module - 禁用 ngx_http_auth_basic_module

    --without-http_autoindex_module - 禁用 ngx_http_autoindex_module

    --without-http_geo_module - 禁用 ngx_http_geo_module

    --without-http_map_module - 禁用 ngx_http_map_module

    --without-http_referer_module - 禁用 ngx_http_referer_module

    --without-http_rewrite_module - 禁用 ngx_http_rewrite_module. 如果启用需要 PCRE 。

    --without-http_proxy_module - 禁用 ngx_http_proxy_module

    --without-http_fastcgi_module - 禁用 ngx_http_fastcgi_module

    --without-http_memcached_module - 禁用 ngx_http_memcached_module

    --without-http_limit_zone_module - 禁用 ngx_http_limit_zone_module

    --without-http_empty_gif_module - 禁用 ngx_http_empty_gif_module

    --without-http_browser_module - 禁用 ngx_http_browser_module

    --without-http_upstream_ip_hash_module - 禁用 ngx_http_upstream_ip_hash_module

    --with-http_perl_module - 启用 ngx_http_perl_module

    --with-perl_modules_path=PATH - 指定 perl 模块的路径

    --with-perl=PATH - 指定 perl 执行文件的路径

    --http-log-path=PATH - Set path to the http access log

    --http-client-body-temp-path=PATH - Set path to the http client request body temporary files

    --http-proxy-temp-path=PATH - Set path to the http proxy temporary files

    --http-fastcgi-temp-path=PATH - Set path to the http fastcgi temporary files

    --without-http - 禁用 HTTP server

    --with-mail - 启用 IMAP4/POP3/SMTP 代理模块

    --with-mail_ssl_module - 启用 ngx_mail_ssl_module

    --with-cc=PATH - 指定 C 编译器的路径

    --with-cpp=PATH - 指定 C 预处理器的路径

    --with-cc-opt=OPTIONS - Additional parameters which will be added to the variable CFLAGS. With the use of the system library PCRE in FreeBSD, it is necessary to indicate --with-cc-opt="-I /usr/local/include". If we are using select() and it is necessary to increase the number of file descriptors, then this also can be assigned here: --with-cc-opt="-D FD_SETSIZE=2048".

    --with-ld-opt=OPTIONS - Additional parameters passed to the linker. With the use of the system library PCRE in FreeBSD, it is necessary to indicate --with-ld-opt="-L /usr/local/lib".

    --with-cpu-opt=CPU - 为特定的 CPU 编译，有效的值包括：pentium, pentiumpro, pentium3, pentium4, athlon, opteron, amd64, sparc32, sparc64, ppc64

    --without-pcre - 禁止 PCRE 库的使用。同时也会禁止 HTTP rewrite 模块。在 "location" 配置指令中的正则表达式也需要 PCRE 。

    --with-pcre=DIR - 指定 PCRE 库的源代码的路径。

    --with-pcre-opt=OPTIONS - Set additional options for PCRE building.

    --with-md5=DIR - Set path to md5 library sources.

    --with-md5-opt=OPTIONS - Set additional options for md5 building.

    --with-md5-asm - Use md5 assembler sources.

    --with-sha1=DIR - Set path to sha1 library sources.

    --with-sha1-opt=OPTIONS - Set additional options for sha1 building.

    --with-sha1-asm - Use sha1 assembler sources.

    --with-zlib=DIR - Set path to zlib library sources.

    --with-zlib-opt=OPTIONS - Set additional options for zlib building.

    --with-zlib-asm=CPU - Use zlib assembler sources optimized for specified CPU, valid values are: pentium, pentiumpro

    --with-openssl=DIR - Set path to OpenSSL library sources

    --with-openssl-opt=OPTIONS - Set additional options for OpenSSL building

    --with-debug - 启用调试日志

    --add-module=PATH - Add in a third-party module found in directory PATH
}



