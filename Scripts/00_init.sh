# 2023-10-01 17:50:31 yunsung hong
# for KTCloud Cent7.8


# KTCloud 자체 미러 작동하지 않음, 기본 repo로 변경
cd /etc/yum.repos.d/
mv CentOS-Ucloud.repo CentOS-Ucloud.repo.org
cp CentOS-Base.repo.org CentOS-Base.repo
ls
# CentOS-Base.repo  CentOS-Base.repo.org  CentOS-Ucloud.repo.org


# deltarpm (패키지 툴) 설치
yum install deltarpm


# httpd 설치
yum install httpd


# httpd enable 및 실행
systemctl status httpd.service
systemctl enable httpd.service
systemctl restart httpd.service


# openjdk 1.8.0 설치
yum install java-1.8.0-openjdk-devel.x86_64
java -version

# openjdk yum 기본 설치 경로는 /usr/lib/jvm 에 있음, JAVA_HOME 은 /usr/lib/jvm/java-1.8.0-openjdk 으로 설정.


# tomcat 8.5.93 설치

useradd -d /usr/local/tomcat -M -s /sbin/nologin tomcat

# 인증서 만료
wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.93/bin/apache-tomcat-8.5.93.zip -P /usr/local/ --no-check-certificate

cd /usr/local/
unzip apache-tomcat-8.5.93.zip

chown -R tomcat:tomcat /usr/local/apache-tomcat-8.5.93/
chmod +x /usr/local/apache-tomcat-8.5.93/bin/*.sh

ln -s apache-tomcat-8.5.93/ tomcat

ls -al # 정상적으로 link 되었는지, 정상적으로 원본 디렉토리 owner 변경되었는지 확인

ls -al /usr/local/tomcat/bin # 정상적으로 owner 변경되었는지, 정상적으로 *.sh 화일에 Execute 권한 적용되었는지 확인

cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Service
After=syslog.target network.target

[Service]
Type=forking

Environment="JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk"
Environment="CATALINA_HOME=/usr/local/tomcat"
Environment="CATALINA_BASE=/usr/local/tomcat"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

ExecStart=/usr/local/tomcat/bin/startup.sh
ExecStop=/usr/local/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat

[Install]
WantedBy=multi-user.target
EOF

systemctl status tomcat.service # 정상적으로 표출되는지 확인

systemctl restart tomcat.service
systemctl status tomcat.service # 정상적으로 실행되었는지 확인


# apache - tomcat 연동 (mod_jk)

# tomcat connector 내려받기

# 인증서 만료
wget https://dlcdn.apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.49-src.tar.gz -P ~ --no-check-certificate
cd ~
tar xzvf tomcat-connectors-1.2.49-src.tar.gz




