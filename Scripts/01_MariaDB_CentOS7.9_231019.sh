## 2023-10-19
## for KTCloud CentOS7.9

## root 환경에서 작업



##### MariaDB 레포지터리 설정

## 디렉터리 생성
mkdir -p /root/INST/mariadb
cd /root/INST/mariadb

## 레포지터리 설정 파일 다운로드
wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup

## 레포지터리 설정 및 확인
bash /root/INST/mariadb/mariadb_repo_setup --mariadb-server-version="mariadb-10.11" --skip-maxscale
cat /etc/yum.repos.d/mariadb.repo



##### MariaDB 설치

# 설치 이전에 EPEL 설치 필수. MariaDB 설치가 진행되지 않을 수 있음.
yum install epel-release

## MariaDB-backup 도 함께 설치
yum install MariaDB-server MariaDB-backup

## 데몬 활성화
systemctl enable mariadb



##### 설정 파일 변경

# datadir 의 변경이 필요한 경우 아래 내용을 확인.

cat << EOF > /etc/my.cnf.d/server.cnf
##
[server]

[mysqld]
bind-address            = 0.0.0.0
port                    = 3306
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
socket                  = /var/lib/mysql/mysql.sock
pid-file                = /var/lib/mysql/mysql.pid
character_set_server    = utf8mb4
collation_server        = utf8mb4_unicode_ci
# 스레드풀을 사용하면 thread_cashe_size는 의미 없음.
thread_handling         = pool-of-threads
#thread_pool_max_threads = 500
lower_case_table_names  = 1
# 0:대소문자 구분.
# 1:대소문자 구분 없음.
# 2:테이블,데이터베이스 생성은 구분, 참조는 구분안함.
log_bin_trust_function_creators = 1
innodb_file_per_table   = 1
innodb_buffer_pool_size = 4096M
skip-name-resolve       = 1
skip-external-locking   = 1
server_id               = 1
expire_logs_days        = 30
log-bin                 = bin_log
relay_log               = relay_log
log_error               = /var/log/mysql/mysql_err.log
#slow_query_log          = 1
#slow_query_log_file     = /var/log/mysql/mysql_slow.log
#long_query_time         = 1
log_slow_query          = 1
log_slow_query_file     = /var/log/mysql/mysql_slow.log
log_slow_query_time     = 1
general_log             = 0
general_log_file        = /var/log/mysql/mysql_general.log

[galera]

[embedded]

[mariadb]

EOF


cat << EOF > /etc/my.cnf.d/mysql-clients.cnf
[mysql]
#no-auto-rehash
default-character-set   = utf8mb4
socket                  = /var/lib/mysql/mysql.sock

[mysql_upgrade]

[mysqladmin]

[mysqlbinlog]

[mysqlcheck]

[mysqldump]
quick
max_allowed_packet      = 64M
default-character-set   = utf8mb4

[mysqlimport]

[mysqlshow]

[mysqlslap]

EOF



# socket, pid 위치를 /run 으로 변경한 경우, 아래 명령을 수행한다.
sed -i -e "
/^socket/Is/\/var\/lib\/mysql/\/run\/mysql/
/^pid-file/Is/\/var\/lib\/mysql/\/run\/mysql/
" /etc/my.cnf.d/server.cnf
sed -i -e "/^socket/Is/\/var\/lib\/mysql/\/run\/mysql/" /etc/my.cnf.d/mysql-clients.cnf

cat << EOF >> /etc/rc.d/rc.local
mkdir -p /run/mysql
chown mysql:mysql /run/mysql
EOF

mkdir /run/mysql
chown mysql:mysql /run/mysql



# datadir 의 위치를 변경한 경우, 아래 명령을 수행한다.
systemctl stop mariadb
mkdir -p /DB/mysql
cp -R -p /var/lib/mysql/* /DB/mysql
chown -R mysql:mysql /DB/mysql
sed -i -e "/^datadir/Is/\/var\/lib\/mysql/\/DB\/mysql/" /etc/my.cnf.d/server.cnf



##### mariadb-secure-installation

# MariaDB 기동 후 작업할 것
systemctl restart mariadb

## 패키지에 포함된 초기 설정 스크립트를 이용

# socket, pid 위치를 변경한 경우, 아래 명령을 수행한다.
sed -i -e "/password='\$esc_pass'/a\    echo \"sock=\/run\/mysql\/mysql.sock\" >>\$config" /bin/mariadb-secure-installation

mariadb-secure-installation
# Enter current password for root (enter for none):
# Switch to unix_socket authentication [Y/n] y
# Change the root password? [Y/n] y	
# New password: 060406x@
# Re-enter new password: 060406x@
# Remove anonymous users? [Y/n] y
# Disallow root login remotely? [Y/n] y
# Remove test database and access to it? [Y/n] y
# Reload privilege tables now? [Y/n] y

mysql -u root -v -t << EOF
grant all privileges on *.* to root@'%' identified by '060406x@' with grant option;
select * from mysql.user;
select * from mysql.db;
show databases;
EOF

# wordpress 설치 시 추가 설정 할 것.
#
# mysql -u root -v -t << EOF
# create database wordpress;
# grant all privileges on wordpress.* to wordpress@% identified by '060406x@';
# select host,user,password from mysql.user;
# EOF
#
# mysql -u wordpress -p << EOF
# show database;
# EOF

# 실행 후 wordpress database 접근 가능한지 확인할 것 !!

##### 종료
yum clean all
cat /dev/null > ~/.bash_history
history -c
reboot
