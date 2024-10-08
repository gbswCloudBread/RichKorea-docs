## 2023-10-25
## for KTCloud CentOS7.9

## root 환경에서 작업



##### httpd 설치
yum install httpd
systemctl enable httpd.service
systemctl restart httpd.service

# 서버로 HTTP 접속 하여 테스트 페이지 확인 할 것 !!



##### 디렉터리 변경

## 디렉터리 생성
mkdir /APP/html


## /APP/html 폴더 접근 권한 설정
cat << EOF >> /etc/httpd/conf.d/userdir.conf   
<Directory "/APP/html">
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
EOF

## DocumentRoot 변경
sed -i -e "/^DocumentRoot/Is/\"\/var\/www\/html\"/\"\/APP\/html\"/" /etc/httpd/conf/httpd.conf



##### httpd 재기동
systemctl restart httpd.service



##### 테스트

cat << EOF > /APP/html/index.html
<h1>Testing..</h1>
EOF

# 서버로 HTTP 접속 하여 테스트 페이지 확인 할 것 !!



##### 종료
yum clean all
cat /dev/null > ~/.bash_history
history -c
reboot