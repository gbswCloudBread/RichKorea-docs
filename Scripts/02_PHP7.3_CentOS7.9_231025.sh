## 2023-10-25
## for KTCloud CentOS7.9

## root 환경에서 작업



##### PHP 설치

# remirepo 및 EPEL 레포지터리 먼저 설정할 것.
yum install epel-release yum-utils        
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
# PHP7.3의 경우. 다른 버전 설치 시 변경할 것.
yum-config-manager --enable remi-php73

## 설치
yum install php php-common php-opcache php-cli php-gd php-curl php-mysqli

## 확인
php -v
# PHP 7.3.33 (cli) (built: Aug  1 2023 13:29:47) ( NTS )
# Copyright (c) 1997-2018 The PHP Group

## httpd 파일 허용 목록 수정 및 httpd 재기동
sed -i -e "/^    DirectoryIndex/Is/$/ index.php/" /etc/httpd/conf/httpd.conf
systemctl restart httpd.service

## PHP info 페이지 생성 및 확인
cat << EOF > /var/www/html/phpinfo.php
<?php 
    phpinfo();
?>
EOF

# 웹 브라우저로 phpinfo.php 접속 및 확인할 것 !!



##### 종료
yum clean all
cat /dev/null > ~/.bash_history
history -c
reboot
