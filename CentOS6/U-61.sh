#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-61(하)\t3. 서비스관리\t3.25 FTP 서비스 확인\t" >> "$rf" 2>&1
echo -en "FTP 서비스가 비활성화 되어 있는 경우\t" >> "$rf" 2>&1

# FTP 서비스 이름
service_name="ftp"

# /etc/services 파일에서 FTP 서비스의 포트 번호 찾기
port=$(grep "^$service_name " /etc/services | awk '{print $2}' | sed 's#/.*##' | uniq)

# FTP 서비스의 구동 여부 확인
if [ -n "$port" ]; then
    # 포트 번호를 기반으로 서비스 활성화 여부 확인
    if ss -tuln | grep -q ":$port "; then
        echo -en "[취약]\t" >> "$rf" 2>&1
        echo -en "\"FTP\" 데몬이 활성화 되어 있는 상태입니다.\t" >> "$rf" 2>&1
		echo "주요정보통신기반시설 가이드를 참고하시어 \"FTP\"데몬을 비활성화 하여 주시기 바랍니다." >> "$rf" 2>&1
    else
        echo -en "[양호]\t" >> "$rf" 2>&1
        echo "\"FTP\" 데몬이 비활성화 되어 있는 상태입니다." >> "$rf" 2>&1
    fi
fi

