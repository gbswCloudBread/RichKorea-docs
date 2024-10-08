## 2023-10-08 16:27:09
## for KTCloud CentOS7.9

## root 환경에서 작업



##### IPv6 비활성화 

## sysctl 설정 변경
cat << EOF >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF

## hosts 파일 내 ipv6 관련 내용 주석처리
sed -i -e "/^::1/Is/^/#/" /etc/hosts
cat /etc/hosts 

## 적용
sysctl -p


##### KTCloud 자체 레포지터리 비활성화
## KTCloud 자체 미러 ucloudbiz.com 으로 접속 시도 시 에러 발생. 미러 닫힘.

## 기존 Ucloud 레포지터리 파일명 변경
mv /etc/yum.repos.d/CentOS-Ucloud.repo /etc/yum.repos.d/CentOS-Ucloud.repo.org

## CentOS-Base 레포지터리 복사
cp /etc/yum.repos.d/CentOS-Base.repo.org /etc/yum.repos.d/CentOS-Base.repo

## 확인
ls /etc/yum.repos.d/



##### yum update 및 install

## yum 캐쉬 청소
yum clean all


## 업데이트
yum -y update


## 필수 패키지 설치
yum -y install bc bind-libs bind-utils chrony expect gcc iptables-services iptables-utils \
               logrotate man-pages net-tools rpm-build rsync telnet traceroute vim-enhanced wget \
               bmon fail2ban fail2ban-systemd nload nmon



##### ntp 시간 동기화

## chrony 설정 - 한국 ntp 서버로 변경
sed -i -e "/^server/Is/centos/kr/" /etc/chrony.conf

## chrony IPv4만 사용하도록 설정
sed -i -e "/^OPTIONS/Is/\"\"/\"-4\"/" /etc/sysconfig/chronyd
cat /etc/sysconfig/chronyd

## restart
systemctl enable chronyd
systemctl restart chronyd

## 확인
chronyc sources
timedatectl status



##### SSH 포트 변경

## sshd_config 수정
## SSH 연결 끊지 말고 대시보드 접속설정에서 포트 변경할 것
sed -i -e "/^#Port/Is/#//" /etc/ssh/sshd_config
sed -i -e "/^Port/Is/22/10022/" /etc/ssh/sshd_config

cat /etc/ssh/sshd_config

systemctl restart sshd
systemctl status sshd

## 꼭 SSH 연결 끊지 말고 하나 더 켜서 접속 확인할 것 !!



##### 종료
yum clean all
cat /dev/null > ~/.bash_history
history -c
reboot
