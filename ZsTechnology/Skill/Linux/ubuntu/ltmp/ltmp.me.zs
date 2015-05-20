[ Ubuntu 13.04 编译安装 tmp {zs}]
# zs 测试中,需要持续学习

demo:
http://sofar.blog.51cto.com/353572/1289681

#nginx编译安装

# 1.libunwind 2.google_perftools
sudo ./configure --prefix=/usr/local/tengine --lock-path=/var/lock/tengine.lock --pid-path=/var/run/tengine.pid --error-log-path=/usr/local/tengine/log/error.log --http-log-path=/usr/local/tengine/log/access.log --user=nobody --group=nogroup --with-pcre=/home/weiyan/zs_ubuntu/lnmp/pcre-8.34 --with-openssl=/home/weiyan/zs_ubuntu/lnmp/openssl-1.0.1c --with-backtrace_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_realip_module --without-select_module --without-poll_module --with-http_concat_module=shared --with-http_sysguard_module=shared --with-http_limit_conn_module=shared --with-http_limit_req_module=shared --with-http_split_clients_module=shared --with-http_footer_filter_module=shared --with-http_sub_module=shared --with-http_access_module=shared --with-http_addition_module=shared --with-http_referer_module=shared --with-http_rewrite_module=shared --with-http_memcached_module=shared --without-http_upstream_check_module --without-http_upstream_least_conn_module --without-http_upstream_keepalive_module --without-http_upstream_ip_hash_module --without-http_geo_module --with-google_perftools_module --with-ld-opt='-ltcmalloc_minimal' --http-client-body-temp-path=/var/run/tengine/tengine_client --http-proxy-temp-path=/var/run/tengine/tengine_proxy --http-fastcgi-temp-path=/var/run/tengine/tengine_fastcgi

#不启用 --with-google_perftools_module --with-ld-opt='-ltcmalloc_minimal'
#zs注:google gperftools优化工具
#zs测试可用
sudo ./configure --prefix=/usr/local/tengine --lock-path=/var/lock/tengine.lock --pid-path=/var/run/tengine.pid --error-log-path=/usr/local/tengine/log/error.log --http-log-path=/usr/local/tengine/log/access.log --user=nobody --group=nogroup --with-pcre=/home/weiyan/zs_ubuntu/lnmp/pcre-8.34 --with-openssl=/home/weiyan/zs_ubuntu/lnmp/openssl-1.0.1c --with-backtrace_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_realip_module --without-select_module --without-poll_module --with-http_concat_module=shared --with-http_sysguard_module=shared --with-http_limit_conn_module=shared --with-http_limit_req_module=shared --with-http_split_clients_module=shared --with-http_footer_filter_module=shared --with-http_sub_module=shared --with-http_access_module=shared --with-http_addition_module=shared --with-http_referer_module=shared --with-http_rewrite_module=shared --with-http_memcached_module=shared --without-http_upstream_check_module --without-http_upstream_least_conn_module --without-http_upstream_keepalive_module --without-http_upstream_ip_hash_module --without-http_geo_module --http-client-body-temp-path=/var/run/tengine/tengine_client --http-proxy-temp-path=/var/run/tengine/tengine_proxy --http-fastcgi-temp-path=/var/run/tengine/tengine_fastcgi

sudo make
sudo make install

#顺序执行一下语句
test -d '/usr/local/tengine' || mkdir -p '/usr/local/tengine'
test -d '/usr/local/tengine/sbin'       || mkdir -p '/usr/local/tengine/sbin'
sudo test ! -f '/usr/local/tengine/sbin/nginx'       || sudo mv '/usr/local/tengine/sbin/nginx'           '/usr/local/tengine/sbin/nginx.old'
sudo cp objs/nginx '/usr/local/tengine/sbin/nginx'
sudo test -d '/usr/local/tengine/conf'       || mkdir -p '/usr/local/tengine/conf'
sudo cp conf/koi-win '/usr/local/tengine/conf'
sudo cp conf/koi-utf '/usr/local/tengine/conf'
sudo cp conf/win-utf '/usr/local/tengine/conf'
sudo test -f '/usr/local/tengine/conf/mime.types'        || cp conf/mime.types '/usr/local/tengine/conf'
sudo cp conf/mime.types '/usr/local/tengine/conf/mime.types.default'
sudo test -f '/usr/local/tengine/conf/fastcgi_params'        || sudo cp conf/fastcgi_params '/usr/local/tengine/conf'
sudo cp conf/fastcgi_params      '/usr/local/tengine/conf/fastcgi_params.default'
sudo test -f '/usr/local/tengine/conf/fastcgi.conf'      || cp conf/fastcgi.conf '/usr/local/tengine/conf'
sudo cp conf/fastcgi.conf '/usr/local/tengine/conf/fastcgi.conf.default'
sudo test -f '/usr/local/tengine/conf/uwsgi_params'      || sudo cp conf/uwsgi_params '/usr/local/tengine/conf'
sudo cp conf/uwsgi_params        '/usr/local/tengine/conf/uwsgi_params.default'
sudo test -f '/usr/local/tengine/conf/scgi_params'       || sudo cp conf/scgi_params '/usr/local/tengine/conf'
sudo cp conf/scgi_params         '/usr/local/tengine/conf/scgi_params.default'
sudo test -f '/usr/local/tengine/conf/nginx.conf'        || sudo cp conf/nginx.conf '/usr/local/tengine/conf/nginx.conf'
sudo cp conf/nginx.conf '/usr/local/tengine/conf/nginx.conf.default'
test -d '/var/run'      || mkdir -p '/var/run'
sudo test -d '/usr/local/tengine/log' ||         sudo mkdir -p '/usr/local/tengine/log'
sudo test -d '/usr/local/tengine/html'       || sudo cp -R html '/usr/local/tengine'
sudo test -f '/usr/local/tengine/conf/browsers'      || sudo cp conf/browsers '/usr/local/tengine/conf'
sudo cp conf/browsers '/usr/local/tengine/conf/browsers'
sudo test -d '/usr/local/tengine/log' ||         sudo mkdir -p '/usr/local/tengine/log'
sudo test -d '/usr/local/tengine/modules/'       || sudo mkdir -p '/usr/local/tengine/modules/'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_sub_filter_module.so'        || sudo unlink '/usr/local/tengine/modules/ngx_http_sub_filter_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_addition_filter_module.so'       || sudo unlink '/usr/local/tengine/modules/ngx_http_addition_filter_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_footer_filter_module.so'         || sudo unlink '/usr/local/tengine/modules/ngx_http_footer_filter_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_concat_module.so'        || sudo unlink '/usr/local/tengine/modules/ngx_http_concat_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_access_module.so'        || sudo unlink '/usr/local/tengine/modules/ngx_http_access_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_limit_conn_module.so'        || sudo unlink '/usr/local/tengine/modules/ngx_http_limit_conn_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_limit_req_module.so'         || sudo unlink '/usr/local/tengine/modules/ngx_http_limit_req_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_split_clients_module.so'         || sudo unlink '/usr/local/tengine/modules/ngx_http_split_clients_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_referer_module.so'       || sudo unlink '/usr/local/tengine/modules/ngx_http_referer_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_rewrite_module.so'       || sudo unlink '/usr/local/tengine/modules/ngx_http_rewrite_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_memcached_module.so'         || sudo unlink '/usr/local/tengine/modules/ngx_http_memcached_module.so'
sudo test ! -f '/usr/local/tengine/modules/ngx_http_sysguard_module.so'      || sudo unlink '/usr/local/tengine/modules/ngx_http_sysguard_module.so'
sudo cp objs/modules/ngx_http_sub_filter_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_addition_filter_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_footer_filter_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_concat_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_access_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_limit_conn_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_limit_req_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_split_clients_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_referer_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_rewrite_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_memcached_module.so /usr/local/tengine/modules/
sudo cp objs/modules/ngx_http_sysguard_module.so /usr/local/tengine/modules/
sudo test -f '/usr/local/tengine/conf/module_stubs'      || sudo cp objs/module_stubs '/usr/local/tengine/conf'
sudo cp objs/module_stubs '/usr/local/tengine/conf/module_stubs'
sudo test -d '/usr/local/tengine/sbin' ||        sudo mkdir -p '/usr/local/tengine/sbin'
sudo cp objs/dso_tool '/usr/local/tengine/sbin/dso_tool'
sudo chmod 0755 '/usr/local/tengine/sbin/dso_tool'
sudo test -d '/usr/local/tengine/include'        || sudo mkdir -p '/usr/local/tengine/include'
sudo test -f 'src/core/nginx.h' && sudo cp 'src/core/nginx.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_config.h' && sudo cp 'src/core/ngx_config.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_core.h' && sudo cp 'src/core/ngx_core.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_log.h' && sudo cp 'src/core/ngx_log.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_palloc.h' && sudo cp 'src/core/ngx_palloc.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_array.h' && sudo cp 'src/core/ngx_array.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_list.h' && sudo cp 'src/core/ngx_list.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_hash.h' && sudo cp 'src/core/ngx_hash.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_buf.h' && sudo cp 'src/core/ngx_buf.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_queue.h' && sudo cp 'src/core/ngx_queue.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_string.h' && sudo cp 'src/core/ngx_string.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_parse.h' && sudo cp 'src/core/ngx_parse.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_inet.h' && sudo cp 'src/core/ngx_inet.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_file.h' && sudo cp 'src/core/ngx_file.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_crc.h' && sudo cp 'src/core/ngx_crc.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_crc32.h' && sudo cp 'src/core/ngx_crc32.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_murmurhash.h' && sudo cp 'src/core/ngx_murmurhash.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_md5.h' && sudo cp 'src/core/ngx_md5.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_sha1.h' && sudo cp 'src/core/ngx_sha1.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_rbtree.h' && sudo cp 'src/core/ngx_rbtree.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_trie.h' && sudo cp 'src/core/ngx_trie.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_segment_tree.h' && sudo cp 'src/core/ngx_segment_tree.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_radix_tree.h' && sudo cp 'src/core/ngx_radix_tree.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_slab.h' && sudo cp 'src/core/ngx_slab.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_times.h' && sudo cp 'src/core/ngx_times.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_shmtx.h' && sudo cp 'src/core/ngx_shmtx.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_connection.h' && sudo cp 'src/core/ngx_connection.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_cycle.h' && sudo cp 'src/core/ngx_cycle.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_conf_file.h' && sudo cp 'src/core/ngx_conf_file.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_resolver.h' && sudo cp 'src/core/ngx_resolver.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_open_file_cache.h' && sudo cp 'src/core/ngx_open_file_cache.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_crypt.h' && sudo cp 'src/core/ngx_crypt.h' '/usr/local/tengine/include'
sudo test -f 'src/event/ngx_event.h' && sudo cp 'src/event/ngx_event.h' '/usr/local/tengine/include'
sudo test -f 'src/event/ngx_event_timer.h' && sudo cp 'src/event/ngx_event_timer.h' '/usr/local/tengine/include'
sudo test -f 'src/event/ngx_event_posted.h' && sudo cp 'src/event/ngx_event_posted.h' '/usr/local/tengine/include'
sudo test -f 'src/event/ngx_event_busy_lock.h' && sudo cp 'src/event/ngx_event_busy_lock.h' '/usr/local/tengine/include'
sudo test -f 'src/event/ngx_event_connect.h' && sudo cp 'src/event/ngx_event_connect.h' '/usr/local/tengine/include'
sudo test -f 'src/event/ngx_event_pipe.h' && sudo cp 'src/event/ngx_event_pipe.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_time.h' && sudo cp 'src/os/unix/ngx_time.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_errno.h' && sudo cp 'src/os/unix/ngx_errno.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_alloc.h' && sudo cp 'src/os/unix/ngx_alloc.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_files.h' && sudo cp 'src/os/unix/ngx_files.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_channel.h' && sudo cp 'src/os/unix/ngx_channel.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_shmem.h' && sudo cp 'src/os/unix/ngx_shmem.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_process.h' && sudo cp 'src/os/unix/ngx_process.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_setaffinity.h' && sudo cp 'src/os/unix/ngx_setaffinity.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_setproctitle.h' && sudo cp 'src/os/unix/ngx_setproctitle.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_atomic.h' && sudo cp 'src/os/unix/ngx_atomic.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_gcc_atomic_x86.h' && sudo cp 'src/os/unix/ngx_gcc_atomic_x86.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_thread.h' && sudo cp 'src/os/unix/ngx_thread.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_socket.h' && sudo cp 'src/os/unix/ngx_socket.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_os.h' && sudo cp 'src/os/unix/ngx_os.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_user.h' && sudo cp 'src/os/unix/ngx_user.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_pipe.h' && sudo cp 'src/os/unix/ngx_pipe.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_sysinfo.h' && sudo cp 'src/os/unix/ngx_sysinfo.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_process_cycle.h' && sudo cp 'src/os/unix/ngx_process_cycle.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_linux_config.h' && sudo cp 'src/os/unix/ngx_linux_config.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_linux.h' && sudo cp 'src/os/unix/ngx_linux.h' '/usr/local/tengine/include'
sudo test -f 'src/os/unix/ngx_syslog.h' && sudo cp 'src/os/unix/ngx_syslog.h' '/usr/local/tengine/include'
sudo test -f 'src/proc/ngx_proc.h' && sudo cp 'src/proc/ngx_proc.h' '/usr/local/tengine/include'
sudo test -f 'src/event/ngx_event_openssl.h' && sudo cp 'src/event/ngx_event_openssl.h' '/usr/local/tengine/include'
sudo test -f 'src/core/ngx_regex.h' && sudo cp 'src/core/ngx_regex.h' '/usr/local/tengine/include'
sudo test -f '/home/weiyan/zs_ubuntu/lnmp/pcre-8.34/pcre.h' && sudo cp '/home/weiyan/zs_ubuntu/lnmp/pcre-8.34/pcre.h' '/usr/local/tengine/include'
sudo test -f '/home/weiyan/zs_ubuntu/lnmp/openssl-1.0.1c/.openssl/include/openssl/ssl.h' && sudo cp '/home/weiyan/zs_ubuntu/lnmp/openssl-1.0.1c/.openssl/include/openssl/ssl.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http.h' && sudo cp 'src/http/ngx_http.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http_request.h' && sudo cp 'src/http/ngx_http_request.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http_config.h' && sudo cp 'src/http/ngx_http_config.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http_core_module.h' && sudo cp 'src/http/ngx_http_core_module.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http_cache.h' && sudo cp 'src/http/ngx_http_cache.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http_variables.h' && sudo cp 'src/http/ngx_http_variables.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http_script.h' && sudo cp 'src/http/ngx_http_script.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http_upstream.h' && sudo cp 'src/http/ngx_http_upstream.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http_upstream_round_robin.h' && sudo cp 'src/http/ngx_http_upstream_round_robin.h' '/usr/local/tengine/include'
sudo test -f 'src/http/ngx_http_busy_lock.h' && sudo cp 'src/http/ngx_http_busy_lock.h' '/usr/local/tengine/include'
sudo test -f 'src/http/modules/ngx_http_ssi_filter_module.h' && sudo cp 'src/http/modules/ngx_http_ssi_filter_module.h' '/usr/local/tengine/include'
sudo test -f 'src/http/modules/ngx_http_ssl_module.h' && sudo cp 'src/http/modules/ngx_http_ssl_module.h' '/usr/local/tengine/include'
sudo test -f 'src/http/modules/ngx_http_reqstat.h' && sudo cp 'src/http/modules/ngx_http_reqstat.h' '/usr/local/tengine/include'
sudo test -f 'objs/ngx_auto_headers.h'  && sudo cp 'objs/ngx_auto_headers.h' '/usr/local/tengine/include'
sudo test -f 'objs/ngx_auto_config.h' && sudo cp 'objs/ngx_auto_config.h' '/usr/local/tengine/include'


#启动:
sudo /usr/local/tengine/sbin/nginx
#重启:
sudo /usr/local/tengine/sbin/nginx -s reload
#停止
sudo /usr/local/tengine/sbin/nginx -s stop

# ./tengine 启动脚本可用	|nginx启动脚本可以参考此文件编写
./tengine
