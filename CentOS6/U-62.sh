#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-62(중)\t3. 서비스관리\t3.26 FTP 계정 shell 제한\t" >> "$rf" 2>&1
echo -en "ftp 계정에 /bin/false 쉘이 부여되어 있는 경우\t" >> "$rf" 2>&1

# FTP 서비스 이름
service_name="ftp"

# /etc/services 파일에서 FTP 서비스의 포트 번호 찾기
port=$(grep "^$service_name " /etc/services | awk '{print $2}' | sed 's#/.*##' | uniq)

# FTP 서비스의 포트 활성화 여부 확인
ftp_active=false
if ss -tuln | grep -q ":$port "; then
    # FTP 서비스가 실행 중인 경우
    ftp_active=true
fi

# FTP 서비스가 비활성화 되어 있는 경우
if ! $ftp_active; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"FTP\" 데몬이 비활성화 되어 있는 상태입니다." >> "$rf" 2>&1
else
    # /etc/passwd에서 ftp 계정의 쉘 설정 확인
    ftp_shell=$(grep "^ftp:" /etc/passwd | cut -d: -f7)
    if [ "$ftp_shell" == "/usr/sbin/nologin" ] || [ "$ftp_shell" == "/bin/false" ]; then
        echo -en "[양호]\t" >> "$rf" 2>&1
        echo "\"FTP\" 기본 계정의 로그인이 불가능하게 설정되어 있는 상태입니다." >> "$rf" 2>&1
    else
        echo -en "[취약]\t" >> "$rf" 2>&1
        echo -en "\"FTP\" 기본 계정의 로그인이 가능하게 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
		echo "주요통신기반시설 가이드를 참고하시어 \"FTP\" 기본 계정의 로그인 쉘을 /bin/false 쉘로 설정하여 주시기 바랍니다." >> "$rf" 2>&1
    fi
fi

