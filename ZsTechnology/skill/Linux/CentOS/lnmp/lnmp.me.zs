准备CentOS yum源，编译环境，各种源码包

[CentOS 6.4  + nginx1.5.7 + php5.5.8 + mysql5.5.22 {zs}]

[http://www.linuxidc.com/Linux/2012-04/59088p5.htm]

1、编译和源码包准备
gcc环境和源码包下载（所有的源码包都放在/usr/local/src目录下）
yum update
yum groupinstall -y "Development Libraries" "Development Tools"

[
zs:
安装依赖的库:
yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers
]


wget http://www.nginx.org/download/nginx-1.1.9.tar.gz
wget http://www.php.net/get/php-5.2.17.tar.gz/from/this/mirror
wget http://php-fpm.org/downloads/php-5.2.14-fpm-0.5.14.diff.gz
wget http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.22.tar.gz/from/http://mysql.he.net/
wget http://ftp.gnu.org/gnu/bison/bison-2.5.tar.gz
wget http://www.cmake.org/files/v2.8/cmake-2.8.7.tar.gz
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
wget http://lcmp.googlecode.com/files/libmcrypt-2.5.8.tar.gz
wget http://vps.googlecode.com/files/mcrypt-2.6.8.tar.gz
wget http://pecl.php.net/get/memcache-3.0.6.tgz
wget "http://downloads.sourceforge.net/mhash/mhash-0.9.9.9.tar.gz?modtime=1175740843&big_mirror=0"
wget http://acelnmp.googlecode.com/files/eaccelerator-0.9.6.1.tar.bz2
wget ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz
wget http://pecl.php.net/get/imagick-2.3.0.tgz
wget http://pecl.php.net/get/PDO_MYSQL-1.0.2.tgz
2、(1)编译安装mysql
cd /usr/local/src/
tar xf cmake-2.8.7.tar.gz
cd cmake-2.8.7
./bootstrap
gmake
gmake install
cd ../
tar zxvf bison-2.5.tar.gz
cd bison-2.5
./configure
make
make install
cd ../
groupadd -r mysql
useradd -g mysql -M -r -s /bin/nologin mysql
mkdir -p /data/3306/mysql
chown -R mysql. /data/3306/mysql
mkdir -p /usr/local/mysql
tar xf mysql-5.5.22.tar.gz
cd mysql-5.5.22
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DSYSCONFDIR=/etc \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS:STRING=utf8,gbk \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_DATADIR=/data/3306/mysql

[
zs:
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DSYSCONFDIR=/etc -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8,gbk -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_DATADIR=/data/3306/mysql
]

[
zs:
编译过程中报错：
Could NOT find Curses (missing:  CURSES_LIBRARY CURSES_INCLUDE_PATH)
CMake Error at cmake/readline.cmake:83 (MESSAGE):
  Curses library not found.  Please install appropriate package,
--
解决：
rm CMakeCache.txt
yum install ncurses
yum install ncurses-devel
yum install bison
--
{
	如果出现一下错误：
cmake .
-- MySQL 5.5.8
-- Could NOT find Curses (missing:  CURSES_LIBRARY CURSES_INCLUDE_PATH)
CMake Error at cmake/readline.cmake:82 (MESSAGE):
  Curses library not found.  Please install appropriate package,

      remove CMakeCache.txt and rerun cmake.On Debian/Ubuntu, package name is libncurses5-dev, on Redhat and derivates it is ncurses-devel.
Call Stack (most recent call first):
  cmake/readline.cmake:126 (FIND_CURSES)
  cmake/readline.cmake:216 (MYSQL_USE_BUNDLED_LIBEDIT)
  CMakeLists.txt:256 (MYSQL_CHECK_READLINE)

-- Configuring incomplete, errors occurred!

安装：
# yum -y install ncurses-devel
}

解决错误之后，重新编译 mysql，知道成功
]

make && make install
cd ../

(2)配置mysql
添加mysql环境变量
vim /etc/profile 添加PATH=$PATH:/usr/local/mysql/bin并重读环境变量  [zs:/etc/profile最后一行添加]
source /etc/profile
添加mysql的库文件
vim /etc/ld.so.conf.d/mysql.cnf 添加/usr/local/mysql/lib这一行代码并重新加载库文件  [zs:如果不存在,mysql.cnf文件,请手动创建]
ldconfig -v
初始化mysql，设置sv启动mysql和mysql的配置文件
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data/3306/mysql/ --user=mysql
ln -sv /usr/local/mysql/include /usr/include/mysql
mkdir -p /data/3306/mysql/data/
mkdir -p /data/3306/mysql/binlog/
mkdir -p /data/3306/mysql/relaylog/
chown -R mysql:mysql /data/3306/mysql/
cp /usr/local/mysql/support-files/my-large.cnf /etc/my.cnf
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
chkconfig --add mysqld    [zs:mysqld 加载到系统{service}服务中]
service mysqld start
优化mysql -->修改其配置文件内容为
# Example MySQL config file for large systems.
#
# This is for a large system with memory = 512M where the system runs mainly
# MySQL.
#
# MySQL programs look for option files in a set of
# locations which depend on the deployment platform.
# You can copy this option file to one of those
# locations. For information about these locations, see:
# http://dev.mysql.com/doc/mysql/en/option-files.html
#
# In this file, you can use all long options that a program supports.
# If you want to know which options a program supports, run the program
# with the "--help" option.

# The following options will be passed to all MySQL clients
[client]
character-set-server = utf8
port        = 3306
socket    = /tmp/mysql.sock

[mysqld]
character-set-server = utf8
port        = 3306
socket    = /tmp/mysql.sock
user        = mysql
basedir = /usr/local/mysql
datadir = /data/3306/mysql
log-error = /data/3306/mysql/mysql_error.log
pid-file = /data/3306/mysql/mysql.pid
open_files_limit        = 10240
back_log = 600
max_connections = 5000
max_connect_errors = 6000
table_cache = 614
external-locking = FALSE
max_allowed_packet = 32M
sort_buffer_size = 1M
join_buffer_size = 1M
thread_cache_size = 300
#thread_concurrency = 8
query_cache_size = 512M
query_cache_limit = 2M
query_cache_min_res_unit = 2k
default-storage-engine = MyISAM
thread_stack = 192K
transaction_isolation = READ-COMMITTED
tmp_table_size = 246M
max_heap_table_size = 246M
long_query_time = 3
log-slave-updates
log-bin = /data/3306/mysql/binlog/binlog
binlog_cache_size = 4M
binlog_format = MIXED
max_binlog_cache_size = 8M
max_binlog_size = 1G
relay-log-index = /data/3306/mysql/relaylog/relaylog
relay-log-info-file = /data/3306/mysql/relaylog/relaylog
relay-log = /data/3306/mysql/relaylog/relaylog
expire_logs_days = 30
key_buffer_size = 256M
read_buffer_size = 1M
read_rnd_buffer_size = 16M
bulk_insert_buffer_size = 64M
myisam_sort_buffer_size = 128M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
myisam_recover

interactive_timeout = 120
wait_timeout = 120

skip-name-resolve
#master-connect-retry = 10
slave-skip-errors = 1032,1062,126,1114,1146,1048,1396

#master-host         =     192.168.1.2
#master-user         =     username
#master-password =     password
#master-port         =    3306

server-id = 1

innodb_additional_mem_pool_size = 16M
innodb_buffer_pool_size = 512M
innodb_data_file_path = ibdata1:256M:autoextend
innodb_file_io_threads = 4
innodb_thread_concurrency = 8
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 16M
innodb_log_file_size = 128M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120
innodb_file_per_table = 0

#log-slow-queries = /data/3306/mysql/slow.log
#long_query_time = 10

replicate-ignore-db = mysql
replicate-ignore-db = test
replicate-ignore-db = information_schema
[mysqldump]
quick
max_allowed_packet = 32M


[
mysql编译常见错误：
二、编译安装mysql常见错误总结及解决办法


错误一：
checking for termcap functions library... configure: error: No curses/termcap library found
解决办法：
下载一个ncurses-5.6.tar.gz，
wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.6.tar.gz
tar zxvf ncurses-5.6.tar.gz
cd ncurses-5.6
./configure --prefix=/usr --with-shared --without-debug
make
make install clean
ncurses-devel


错误二：
 Could NOT find Curses (missing:  CURSES_LIBRARY CURSES_INCLUDE_PATH)
CMake Error at cmake/readline.cmake:83 (MESSAGE):
 Curses library not found.  Please install appropriate package,
解决办法：
yum install ncurses-devel

错误三：Warning: Bison executable not found in PATH
解决办法：
yum install bison

错误四：rm: cannot remove `libtoolT': No such file or directory
解决办法：
1、确认libtool是否已经安装，如果没有安装的话，则先安装libtool
# yum -y install libtool
2、分别执行以下三条命令：
# autoreconf --force --install
# libtoolize --automake --force
# automake --force --add-missing
注：如果上面的办法无法解决的话，直接打开configure 文件
把 $RM “$cfgfile” 那行删除掉
$RM “$cfgfile”  大约在 42302 行
]


=========


3、编译安装php---需要打两个补丁很纳闷为啥不用5.3版本后的吧（主要是公司开个在5.2版本上开发程序。。。）
tar xf libiconv-1.14.tar.gz
cd libiconv-1.14
./configure --prefix=/usr/local
make && make install    [zs: make的时候,make[1]: Entering directory `/home/weiyan1/zs/libmcrypt-2.5.8/libltdl' ;不是出错信息,可以无视]
cd ../

tar xf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure
make && make install
ldconfig -v
cd libltdl/
./configure --enable-ltdl-install
make && make install
cd ../../
tar zxvf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9/
./configure
make && make install
cd ../
vim /etc/ld.so.conf.d/local.conf 添加    [zs:/etc/ld.so.conf.d/local.conf,如果没有这个文件,请创建此文件]
/usr/local/lib
ldconfig -v

tar zxvf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8/
/sbin/ldconfig
./configure
make && make install
cd ../
cp /usr/lib64/libjpeg.so* /usr/lib/
cp /usr/lib64/libpng*  /usr/lib/
tar xf php-5.2.17.tar.gz

直接编译php即可：zs
[
zs:注 php5.3之后不用打 fpm补丁，php内核中已经集成

gzip -cd php-5.2.14-fpm-0.5.14.diff.gz | patch -d php-5.2.17
cd php-5.2.17 -p1
tar xf ../laruence-laruence.github.com-b648cb1.tar.gz

patch -p1 < ../laruence-laruence.github.com-b648cb1/php-5.2-max-input-vars/php-5.2.17-max-input-vars.patch
]


./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-discard-path --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fastcgi --enable-fpm --enable-force-cgi-redirect --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap

[
zs:注
编译过程中,可能会提示缺少依赖,按照提示装好依赖包,在重新编译PHP知道成功为止
]

make ZEND_EXTRA_LIBS='-liconv'
make install
cp cp php.ini-development /usr/local/php/etc/php.ini
cd ../

[
ps上面第二个补丁下载地址http://www.kuaipan.cn/file/id_4516853896446549.html
第一补丁我打的是php-5.2.14-fpm-0.5.14.diff.gz 这个版本，因为打php-5.2.17-fpm-0.5.14.diff.gz 这个版本./configure会报下面错误
Installing PEAR environment:      /usr/local/php/lib/php/
/usr/local/src/php-5.2.17/sapi/cli/php: error while loading shared libraries: libmysqlclient.so.18: cannot open shared object file: No such file or directory
]

tar xf memcache-3.0.6.tgz
cd memcache-3.0.6
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
[
zs注：
打开 php.ini 增加：
extension=/usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/memcache.so
]
cd ../
tar xf eaccelerator-0.9.6.1.tar.bz2
cd eaccelerator-0.9.6.1/
/usr/local/php/bin/phpize
./configure --enable-eaccelerator=shared --with-php-config=/usr/local/php/bin/php-config
make && make install
cd ../
tar zxvf PDO_MYSQL-1.0.2.tgz
cd PDO_MYSQL-1.0.2/
/usr/local/webserver/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-pdo-mysql=/usr/local/mysql
make && make install
cd ../
tar zxvf ImageMagick.tar.gz
cd ImageMagick-6.5.1-2/
./configure
make && make install
cd ../
tar zxvf imagick-2.3.0.tgz
cd imagick-2.3.0/
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
cd ../

上面make  install结果记下，后面有用
Installing shared extensions:     /usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/


---

修改php.ini文件
查找/usr/local/php/etc/php.ini中的extension_dir = "./"
　　修改为extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/"
　　[zs:
	修改为extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/"
	修改为extension_dir = "/usr/local/php/include/php/ext/pdo/"
	]
并在此行后增加以下几行
　　extension = "memcache.so"
　　extension = "pdo_mysql.so"
　　extension = "imagick.so"
　　再查找output_buffering = Off
　　修改为output_buffering = On
　　再查找; cgi.fix_pathinfo=0
　　修改为cgi.fix_pathinfo=0
配置eAccelerator加速PHP（加速有很多选择，下次我就换个测试下）
vim /usr/local/php/etc/php.ini在文件最后添加下面代码
[eaccelerator]
zend_extension="/usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/eaccelerator.so"
eaccelerator.shm_size="64"
eaccelerator.cache_dir="/usr/local/eaccelerator_cache"
eaccelerator.enable="1"
eaccelerator.optimizer="1"
eaccelerator.check_mtime="1"
eaccelerator.debug="0"
eaccelerator.filter=""
eaccelerator.shm_max="0"
eaccelerator.shm_ttl="3600"
eaccelerator.shm_prune_period="3600"
eaccelerator.shm_only="0"
eaccelerator.compress="1"
eaccelerator.compress_level="9"


添加www用户，nginx和FastCGI用
groupadd -r www
useradd -r -g www -s /bin/false -M www
创建php-fpm配置文件
rm -rf /usr/local/php/etc/php-fpm.conf
vim /usr/local/php/etc/php-fpm.conf
[
zs:
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
]

[
zs:  **
修改环境变量，让php可执行文件能像linux命令一样
vim /etc/profile
在最低端加上
PATH=/usr/local/php/bin:$PATH
PATH=/usr/local/php/sbin:$PATH
source /etc/profile 使修改立即生效
--
设置成功后用
php --help
可以查看php命令的参数
{
	设置成功后：
	#php -v
	PHP 5.5.8 (cli) (built: Jan 13 2014 04:37:29)
	Copyright (c) 1997-2013 The PHP Group
	Zend Engine v2.5.0, Copyright (c) 1998-2013 Zend Technologies
	---
	#php -m   [查看php已经安装的模块{扩展}]
	[PHP Modules]
	bcmath
	Core
	ctype
	curl
	date
	dom
	ereg
	fileinfo
	filter
	gd
	hash
	iconv
	json
	ldap
	libxml
	mbstring
	mcrypt
	memcache
	mhash
	mysql
	mysqli
	openssl
	pcntl
	pcre
	PDO
	pdo_mysql
	pdo_sqlite
	Phar
	posix
	Reflection
	session
	shmop
	SimpleXML
	soap
	sockets
	SPL
	sqlite3
	standard
	sysvsem
	tokenizer
	xhprof
	xml
	xmlreader
	xmlrpc
	xmlwriter
	zip
	zlib
	[Zend Modules]

}
-
设置php-fpm开机启动
[root@omc-0 php-5.4.3]# cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
[root@omc-0 php-5.4.3]# chmod 755 /etc/init.d/php-fpm
[root@omc-0 php-5.4.3]# chkconfig --add php-fpm
{zs:
	[root@localhost php-5.5.8]# find / -name init.d.php-fpm
	/home/weiyan1/zs/php-5.5.8/sapi/fpm/init.d.php-fpm
	[root@localhost php-5.5.8]# cp /home/weiyan1/zs/php-5.5.8/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
	[root@localhost php-5.5.8]# chmod 755 /etc/init.d/php-fpm
	[root@localhost php-5.5.8]# chkconfig --list php-fpm
	service php-fpm supports chkconfig, but is not referenced in any runlevel (run 'chkconfig --add php-fpm')
	[root@localhost php-5.5.8]# chkconfig --add php-fpm
	[root@localhost php-5.5.8]# chkconfig --list php-fpm
	php-fpm        	0:off	1:off	2:on	3:on	4:on	5:on	6:off

	{
	service php-fpm {start|stop|force-quit|restart|reload|status}
	}
}
]


<?xml version="1.0" ?>
<configuration>

    All relative paths in this config are relative to php's install prefix

    <section name="global_options">

        Pid file
        <value name="pid_file">/usr/local/php/logs/php-fpm.pid</value>

        Error log file
        <value name="error_log">/usr/local/php/logs/php-fpm.log</value>

        Log level
        <value name="log_level">notice</value>

        When this amount of php processes exited with SIGSEGV or SIGBUS ...
        <value name="emergency_restart_threshold">10</value>

        ... in a less than this interval of time, a graceful restart will be initiated.
        Useful to work around accidental curruptions in accelerator's shared memory.
        <value name="emergency_restart_interval">1m</value>

        Time limit on waiting child's reaction on signals from master
        <value name="process_control_timeout">5s</value>

        Set to 'no' to debug fpm
        <value name="daemonize">yes</value>

    </section>

    <workers>

        <section name="pool">

            Name of pool. Used in logs and stats.
            <value name="name">default</value>

            Address to accept fastcgi requests on.
            Valid syntax is 'ip.ad.re.ss:port' or just 'port' or '/path/to/unix/socket'
            <value name="listen_address">127.0.0.1:9000</value>

            <value name="listen_options">

                Set listen(2) backlog
                <value name="backlog">-1</value>

                Set permissions for unix socket, if one used.
                In Linux read/write permissions must be set in order to allow connections from web server.
                Many BSD-derrived systems allow connections regardless of permissions.
                <value name="owner"></value>
                <value name="group"></value>
                <value name="mode">0666</value>
            </value>

            Additional php.ini defines, specific to this pool of workers.
            <value name="php_defines">
                <value name="sendmail_path">/usr/sbin/sendmail -t -i</value>
                <value name="display_errors">0</value>
            </value>

            Unix user of processes
            <value name="user">www</value>

            Unix group of processes
            <value name="group">www</value>

            Process manager settings
            <value name="pm">

                Sets style of controling worker process count.
                Valid values are 'static' and 'apache-like'
                <value name="style">static</value>

                Sets the limit on the number of simultaneous requests that will be served.
                Equivalent to Apache MaxClients directive.
                Equivalent to PHP_FCGI_CHILDREN environment in original php.fcgi
                Used with any pm_style.
                <value name="max_children">128</value>

                Settings group for 'apache-like' pm style
                <value name="apache_like">

                    Sets the number of server processes created on startup.
                    Used only when 'apache-like' pm_style is selected
                    <value name="StartServers">20</value>

                    Sets the desired minimum number of idle server processes.
                    Used only when 'apache-like' pm_style is selected
                    <value name="MinSpareServers">5</value>

                    Sets the desired maximum number of idle server processes.
                    Used only when 'apache-like' pm_style is selected
                    <value name="MaxSpareServers">35</value>

                </value>

            </value>

            The timeout (in seconds) for serving a single request after which the worker process will be terminated
            Should be used when 'max_execution_time' ini option does not stop script execution for some reason
            '0s' means 'off'
            <value name="request_terminate_timeout">0s</value>

            The timeout (in seconds) for serving of single request after which a php backtrace will be dumped to slow.log file
            '0s' means 'off'
            <value name="request_slowlog_timeout">0s</value>

            The log file for slow requests
            <value name="slowlog">logs/slow.log</value>

            Set open file desc rlimit
            <value name="rlimit_files">65535</value>

            Set max core size rlimit
            <value name="rlimit_core">0</value>

            Chroot to this directory at the start, absolute path
            <value name="chroot"></value>

            Chdir to this directory at the start, absolute path
            <value name="chdir"></value>

            Redirect workers' stdout and stderr into main error log.
            If not set, they will be redirected to /dev/null, according to FastCGI specs
            <value name="catch_workers_output">yes</value>

            How much requests each process should execute before respawn.
            Useful to work around memory leaks in 3rd party libraries.
            For endless request processing please specify 0
            Equivalent to PHP_FCGI_MAX_REQUESTS
            <value name="max_requests">1024</value>

            Comma separated list of ipv4 addresses of FastCGI clients that allowed to connect.
            Equivalent to FCGI_WEB_SERVER_ADDRS environment in original php.fcgi (5.2.2+)
            Makes sense only with AF_INET listening socket.
            <value name="allowed_clients">127.0.0.1</value>

            Pass environment variables like LD_LIBRARY_PATH
            All $VARIABLEs are taken from current environment
            <value name="environment">
                <value name="HOSTNAME">$HOSTNAME</value>
                <value name="PATH">/usr/local/bin:/usr/bin:/bin</value>
                <value name="TMP">/tmp</value>
                <value name="TMPDIR">/tmp</value>
                <value name="TEMP">/tmp</value>
                <value name="OSTYPE">$OSTYPE</value>
                <value name="MACHTYPE">$MACHTYPE</value>
                <value name="MALLOC_CHECK_">2</value>
            </value>

        </section>

    </workers>

</configuration>


---

/usr/local/php/sbin/php-fpm start 启动FastCGI
下面是伪sv启动FastCGI脚本，仅供参考。
vim /etc/init.d/phpfcgi 添加下面代码
#! /bin/sh
#
# phpcgi                Startup script for the Apache fastcgi Server
#
# chkconfig:345    85 15
# description:phpcgi
# processname: phpcgi
# config: /usr/local/php/etc/php-fpm.conf
# pidfile: /usr/local/php/logs/php-fpm.pid
# Source function library.
. /etc/rc.d/init.d/functions

php_fpm_BIN=/usr/local/php/bin/php-cgi
php_fpm_CONF=/usr/local/php/etc/php-fpm.conf
php_fpm_PID=/usr/local/php/logs/php-fpm.pid


php_opts="--fpm-config $php_fpm_CONF"


wait_for_pid () {
                try=0

                while test $try -lt 35 ; do

                                case "$1" in
                                                'created')
                                                if [ -f "$2" ] ; then
                                                                try=''
                                                                break
                                                fi
                                                ;;

                                                'removed')
                                                if [ ! -f "$2" ] ; then
                                                                try=''
                                                                break
                                                fi
                                                ;;
                                esac

                                echo -n .
                                try=`expr $try + 1`
                                sleep 1

                done

}

case "$1" in
                start)
                                echo -n "Starting php_fpm "

                                $php_fpm_BIN --fpm $php_opts

                                if [ "$?" != 0 ] ; then
                                                echo " failed"
                                                echo -e "\033[31mStarting php_fpm .............[failed]\033[0m"
                                                exit 1
                                fi


                                wait_for_pid created $php_fpm_PID

                                if [ -n "$try" ] ; then
                                                echo " failed"
                                                echo -e "\033[31mStarting php_fpm .............[failed]\033[0m"
                                                exit 1
                                else
                                                echo " done"
                                fi
                                echo -e "\033[32mStarting php_fpm .............[ok]\033[0m"
                ;;

                stop)
                                echo -n "Shutting down php_fpm "

                                if [ ! -r $php_fpm_PID ] ; then
                                                echo -e "\033[31mwarning, no pid file found - php-fpm is not running ?\033[0m"
                                                exit 1
                                fi

                                kill -TERM `cat $php_fpm_PID`

                                wait_for_pid removed $php_fpm_PID

                                if [ -n "$try" ] ; then
                                                echo -e "\033[31mStoping php_fpm .............[failed]\033[0m"
                                                exit 1
                                else
                                                echo " done"
                                fi
                                echo -e "\033[32m Stoping php_fpm .............[ok]\033[0m"
                ;;

                quit)
                                echo -n "Gracefully shutting down php_fpm "

                                if [ ! -r $php_fpm_PID ] ; then
                                                echo -e "\033[31mwarning, no pid file found - php-fpm is not running ?\033[0m"
                                                exit 1
                                fi

                                kill -QUIT `cat $php_fpm_PID`

                                wait_for_pid removed $php_fpm_PID

                                if [ -n "$try" ] ; then
                                                echo -e "\033[31mquiting php_fpm .............[failed]\033[0m"
                                                exit 1
                                else
                                                echo " done"
                                fi
                                echo -e "\033[32mquiting    php_fpm .............[ok]\033[0m"
                ;;

                restart)
                                $0 stop
                                $0 start
                ;;

                reload)

                                echo -n "Reload service php-fpm "

                                if [ ! -r $php_fpm_PID ] ; then
                                                echo -e "\033[31mwarning, no pid file found - php-fpm is not running ?\033[0m"
                                                exit 1
                                fi

                                kill -USR2 `cat $php_fpm_PID`

                                echo -e "\033[32mreload    php_fpm .............[ok]\033[0m"
                ;;

                logrotate)

                                echo -n "Re-opening php-fpm log file "

                                if [ ! -r $php_fpm_PID ] ; then
                                                echo "warning, no pid file found - php-fpm is not running ?"
                                                exit 1
                                fi

                                kill -USR1 `cat $php_fpm_PID`

                                echo -e "\033[32mlogrotate    php_fpm .............[ok]\033[0m"
                ;;

                *)
                                echo -e "\033[32mUsage: $0 {start|stop|quit|restart|reload|logrotate}\033[0m"
                                exit 1
                ;;

esac
chmod +x /etc/init.d/phpfcgi
chkconfig --add phpfcgi

测试如下
[root@localhost ~]# service phpfcgi start
Starting php_fpm  done
Starting php_fpm .............[ok]
[root@localhost ~]# service phpfcgi stop
Shutting down php_fpm ...... done
Stoping php_fpm .............[ok]


[
php编译常见错误：
一、编译安装php常见错误总结及解决办法

错误 1
checking for xml2-config path...
configure: error: xml2-config not found. Please check your libxml2 installation.
解决办法：
# yum -y install libxml2-devel


错误 2
checking for BZip2 in default path... not found
configure: error: Please reinstall the BZip2 distribution
解决办法：
# yum install -y  bzip2-devel


错误 3
If configure fails try --with-vpx-dir=<DIR>
configure: error: png.h not found.
解决办法：
# yum -y install libpng-devel


错误 4
If configure fails try --with-xpm-dir=<DIR>
configure: error: freetype.h not found.
解决办法：
# yum -y install freetype-devel


错误 5
checking for specified location of the MySQL UNIX socket... no
configure: error: Cannot find MySQL header files under /usr/local/mysql.
Note that the MySQL client library is not bundled anymore!
解决办法：
安装mysql


错误 6
configure: error: mcrypt.h not found. Please reinstall libmcrypt.
解决办法：安装libmcrypt
wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/attic/libmcrypt/libmcrypt-2.5.7.tar.gz
tar -zxvf libmcrypt-2.5.7.tar.gz
cd libmcrypt-2.5.7
mkdir -p /usr/local/libmcrytp
./configure prefix=/usr/local/libmcrytp/
make
make install


错误 7
If configure fails try --with-vpx-dir=<DIR> configure: error: jpeglib.h not found.
解决办法：
yum install libjpeg* libpng* freetype* libjpeg-devel* libpng-devel* freetype-devel* -y


错误 8
configure: error: Cannot find ldap.h
解决办法：
检查：
yum list openldap
yum list openldap-devel
安装 ：
yum install openldap
yum install openldap-devel

错误 9
configure: error: Cannot find ldap libraries in /usr/lib.
解决办法：
cp -frp /usr/lib64/libldap* /usr/lib/


错误 10
checking for known struct flock definition... configure: error: Don't know how to define struct flock on this system, set --enable-opcache=no
这是因为编译的时候找不到有关库文件，解决方法：
{
解决办法：
编辑 /etc/ld.so.conf 加入/usr/local/lib    [zs:若没有此文件,请创建]
加入 /usr/local/lib
再执行：ldconfig [-v]  生效
}
{
解决方法：
sudo ln -s /usr/local/mysql/lib/libmysqlclient.so /usr/lib/
sudo ln -s /usr/local/mysql/lib/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.18
}
-
zs:注如果以上两种方法,都无法解决,可能是缺少必须的'依赖包',请安装之.
]


[
zs:注
编译安装 pdo_mysql.so
进入php扩展目录
cd ./ext/pdo_mysql
/usr/local/php/bin/phpize
./configure  --with-php-config=/usr/local/php/bin/php-config --with-pdo-mysql=/usr/local/mysql/
make && make install
[记录 make install之后的 ：/usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/]
-
vim php.ini
extension=/usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/pdo_mysql.so
-
安装完成，重启 fastcgi;重启nginx不会生效
service php-fpm restart
即可
]


=========


4、安装nginx
tar xf pcre-8.20.tar.bz2
cd pcre-8.20
./configure
make && make install
cd ../
tar xf nginx-1.1.9.tar.gz
cd nginx-1.1.9
	./configure \
     --prefix=/usr \
     --sbin-path=/usr/sbin/nginx \
     --conf-path=/etc/nginx/nginx.conf \
     --error-log-path=/var/log/nginx/error.log \
     --http-log-path=/var/log/nginx/access.log \
     --pid-path=/var/run/nginx/nginx.pid    \
     --lock-path=/var/lock/nginx.lock \
     --user=www \
     --group=www \
     --with-http_ssl_module \
     --with-http_flv_module \
     --with-http_stub_status_module \
     --with-http_gzip_static_module \
     --http-client-body-temp-path=/var/usr/local/src/nginx/client/ \
     --http-proxy-temp-path=/var/usr/local/src/nginx/proxy/ \
     --http-fastcgi-temp-path=/var/usr/local/src/nginx/fcgi/ \
     --with-pcre \
     [
     zs:
     ./configure --prefix=/usr/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --http-client-body-temp-path=/var/usr/local/src/nginx/client/ --http-proxy-temp-path=/var/usr/local/src/nginx/proxy/ --http-fastcgi-temp-path=/var/usr/local/src/nginx/fcgi/ --with-pcre
     ]
#make && make install
make
make install
[
zs注释：
之后,会有 test -d || mkdir || cp 等命令输出提示；要把下面的所有命令执行一遍。次操作是 copy nginx文件到 编译安装的指定目录
]

cd ..
修改nginx配置文件
 mv  /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
vim /etc/nginx/nginx.conf  添加如下代码
user  www www;
worker_processes  4;
#error_log  /var/log/nginx、error.log;
#error_log  /var/log/nginx/error.log  notice;
#error_log  /var/log/nginx/error.log  info;
#Specifies the value for maximum file descriptors that can be opened by this process.
worker_rlimit_nofile 65535;
events
{
  use epoll;
  worker_connections 65535;
}
http
{
  include       mime.types;
  default_type  application/octet-stream;
  #charset  gb2312;
  server_names_hash_bucket_size 128;
  client_header_buffer_size 32k;
  large_client_header_buffers 4 32k;
  client_max_body_size 8m;
  sendfile on;
  tcp_nopush     on;
  keepalive_timeout 60;
  tcp_nodelay on;
  fastcgi_connect_timeout 300;
  fastcgi_send_timeout 300;
  fastcgi_read_timeout 300;
  fastcgi_buffer_size 64k;
  fastcgi_buffers 4 64k;
  fastcgi_busy_buffers_size 128k;
  fastcgi_temp_file_write_size 128k;
  gzip on;
  gzip_min_length  1k;
  gzip_buffers     4 16k;
  gzip_http_version 1.0;
  gzip_comp_level 2;
  gzip_types       text/plain application/x-javascript text/css application/xml;
  gzip_vary on;
  #limit_zone  crawler  $binary_remote_addr  10m;
  server
  {
    listen       80;
    server_name www.gabylinux.com;
    index index.html index.htm index.php;
    root  html;
    #limit_conn   crawler  20;
    location ~ .*\.(php|php5)?$
    {
      #fastcgi_pass  unix:/tmp/php-cgi.sock;
      fastcgi_pass  127.0.0.1:9000;
      fastcgi_index index.php;
      include fcgi.conf;
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
      expires      30d;
    }
    location ~ .*\.(js|css)?$
    {
      expires      1h;
    }
    log_format  access  '$remote_addr - $remote_user [$time_local] "$request" '
              '$status $body_bytes_sent "$http_referer" '
              '"$http_user_agent" $http_x_forwarded_for';
    access_log  /var/log/nginx/access.log   access;
 }
}

为nginx提供sv启动脚本
vim /etc/init.d/nginx    [zs注：/etc/init.d/nginx文件,则创建]

#!/bin/sh
#
# nginx - this script starts and stops the nginx daemon
#
# chkconfig:     - 85 15
# description:    Nginx is an HTTP(S) server, HTTP(S) reverse \
#                             proxy and IMAP/POP3 proxy server
# processname: nginx
# config:            /etc/nginx/nginx.conf
# config:            /etc/sysconfig/nginx
# pidfile:         /var/run/nginx.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

nginx="/usr/sbin/nginx"
prog=$(basename $nginx)

NGINX_CONF_FILE="/etc/nginx/nginx.conf"

[ -f /etc/sysconfig/nginx ] && . /etc/sysconfig/nginx

lockfile=/var/lock/subsys/nginx

make_dirs() {
     # make required directories
     user=`nginx -V 2>&1 | grep "configure arguments:" | sed 's/[^*]*--user=\([^ ]*\).*/\1/g' -`
     options=`$nginx -V 2>&1 | grep 'configure arguments:'`
     for opt in $options; do
             if [ `echo $opt | grep '.*-temp-path'` ]; then
                     value=`echo $opt | cut -d "=" -f 2`
                     if [ ! -d "$value" ]; then
                             # echo "creating" $value
                             mkdir -p $value && chown -R $user $value
                     fi
             fi
     done
}

start() {
        [ -x $nginx ] || exit 5
        [ -f $NGINX_CONF_FILE ] || exit 6
        make_dirs
        echo -n $"Starting $prog: "
        daemon $nginx -c $NGINX_CONF_FILE
        retval=$?
        echo
        [ $retval -eq 0 ] && touch $lockfile
        return $retval
}

stop() {
        echo -n $"Stopping $prog: "
        killproc $prog -QUIT
        retval=$?
        echo
        [ $retval -eq 0 ] && rm -f $lockfile
        return $retval
}

restart() {
        configtest || return $?
        stop
        sleep 1
        start
}

reload() {
        configtest || return $?
        echo -n $"Reloading $prog: "
        killproc $nginx -HUP
        RETVAL=$?
        echo
}

force_reload() {
        restart
}

configtest() {
    $nginx -t -c $NGINX_CONF_FILE
}

rh_status() {
        status $prog
}

rh_status_q() {
        rh_status >/dev/null 2>&1
}

case "$1" in
        start)
                rh_status_q && exit 0
                $1
                ;;
        stop)
                rh_status_q || exit 0
                $1
                ;;
        restart|configtest)
                $1
                ;;
        reload)
                rh_status_q || exit 7
                $1
                ;;
        force-reload)
                force_reload
                ;;
        status)
                rh_status
                ;;
        condrestart|try-restart)
                rh_status_q || exit 0
                        ;;
        *)
                echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
                exit 2
esac

chkconfig --add nginx

[
zs注：
[root@localhost nginx-1.5.7]# chkconfig --add nginx
[root@localhost nginx-1.5.7]# service nginx start
env: /etc/init.d/nginx: Permission denied							[权限不够]
[root@localhost nginx-1.5.7]# chmod -R 755 /etc/init.d/nginx
[root@localhost nginx-1.5.7]# service nginx start
Starting nginx:                                            [  OK  ]
[root@localhost nginx-1.5.7]#
]

测试如下
[root@localhost ~]# service nginx start
Starting nginx:                                            [  OK  ]
[root@localhost ~]# service nginx restart
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
Stopping nginx:                                            [  OK  ]
Starting nginx:                                            [  OK  ]
[root@localhost ~]#





