#CentOS 6.4 + apache-2.4.7 + php-5.5.7 编译安装 [zs]
#===


apache 编译安装：


#===
php 编译安装：


[
注：php的phpize
{
php后续安装PDO扩展：
1.进入PHP源码包ext/pdo目录
 
cd ext/pdo
 
2.执行/usr/local/php/bin/phpize[假设PHP的安装目录为/usr/local/php]
 
 /usr/local/php/bin/phpize
3.配置扩展pdo
 
./configure \
--with-php-config=/usr/local/php/bin/php-config \
--enable-pdo=shared
 
4.编译pdo
 
make
 
5.安装
 
make install
[root@localhost pdo]# make install
成功则出现
Installing shared extensions:     /usr/local/php//lib/php/extensions/no-debug-non-zts-20060613/
Installing header files:          /usr/local/php//include/php/
Installing PDO headers:          /usr/local/php//include/php/ext/pdo/
 
说明在/usr/local/php//lib/php/extensions/no-debug-non-zts-20060613/目录下生成了pdo.so文件

}
]
