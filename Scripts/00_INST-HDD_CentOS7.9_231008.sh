## 2023-10-08 18:58:36
## for KTCloud CentOS7.9

## root 환경에서 작업
## KTCloud 대시보드에서 DATA HDD 를 추가한 후 진행
## HDD 는 /dev/xvdb 기준으로 작성. 구성 환경에 따라 조정 필요.
## Mount point 는 /DB 기준으로 작성. 구성 환경에 따라 조정 필요.



##### 새 HDD 인식 확인

fdisk -l
# Disk /dev/xvdb: 32.2 GB, 32212254720 bytes, 62914560 sectors
# Units = sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes



##### 새 HDD 파티션 생성

fdisk /dev/xvdb
# Command (m for help): p 
# Command (m for help): n
# Partition type:
#    p   primary (0 primary, 0 extended, 4 free)
#    e   extended
# Select (default p): 
# Partition number (1-4, default 1): 
# First sector (2048-41943039, default 2048): 
# Using default value 2048
# Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039): 
# Using default value 41943039
# Partition 1 of type Linux and of size 20 GiB is set
#
# Command (m for help): p

## 파티션 /dev/xvdb1 확인 후 저장 및 종료

# Command (m for help): w

## 확인
fdisk -l
# Disk /dev/xvdb: 32.2 GB, 32212254720 bytes, 62914560 sectors
# Units = sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes
# Disk label type: dos
# Disk identifier: 0x4d19f18f
#
#     Device Boot      Start         End      Blocks   Id  System
# /dev/xvdb1            2048    62914559    31456256   83  Linux



##### 파일 시스템 생성

mkfs.ext4 /dev/xvdb1



##### Disk Mount 및 fstab 수정

mkdir /DB
mount /dev/xvdb1 /DB
df
# Filesystem     1K-blocks    Used Available Use% Mounted on
# ...
# /dev/xvdb1      30831524   45080  29197248   1% /DB

cat >> /etc/fstab << EOF
/dev/xvdb1 /DB ext4 defaults,nofail 0 0
EOF
## 꼭 fstab 열어서 기존 내용과 라인 맞출 것 !!
## 여러 개 붙으면 읽기 힘듬.



##### 종료
cat /dev/null > ~/.bash_history
history -c
reboot
## 재기동 후 정상적으로 인식되는지 확인 할 것 !!