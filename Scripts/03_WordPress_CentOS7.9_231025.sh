## 2023-10-25
## for KTCloud CentOS7.9

## root 환경에서 작업

## 시작 전, MariaDB 설치 스크립트의
## WordPress 추가 설정 수행할 것 !!
## 수행하지 않을 시 DB 작동 불능.

##### WordPress 내려받기

# 원하는 버젼의 WordPress 를 내려받을 것.
cd /APP/html/
wget https://ko.wordpress.org/wordpress-6.3.2-ko_KR.tar.gz
tar zxvf wordpress-6.3.2-ko_KR.tar.gz
ls -al 
rm -f wordpress-6.3.2-ko_KR.tar.gz

chmod 0755 wordpress
chown -R apache.apache wordpress



##### WordPress DB 설정

cd wordpress
cp wp-config-sample.php wp-config.php

sed -i -e "
/DB_NAME/Is/database_name_here/wordpress/
/DB_USER/Is/username_here/wordpress/
/DB_PASSWORD/Is/password_here/060406x@/
/DB_HOST/Is/localhost/10.30.5.33/
/DB_CHARSET/Is/utf8/utf8mb4/
" wp-config.php 



##### apache 설정 변경

# apache 에서 내부 파일을 자유롭게 수정하도록 설정

cat << EOF >> /etc/httpd/conf.d/userdir.conf
<Directory "/APP/html/wordpress">
        AllowOverride All
</Directory>
EOF

# 서버로 HTTP 접속 하여 초기 설정 수행 할 것 !!


##### 종료
cat /dev/null > ~/.bash_history
history -c
reboot