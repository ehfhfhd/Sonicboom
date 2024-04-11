#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-64(중)\t3. 서비스관리\t3.28 FTP 접속 시 root 계정 차단\t" >> "$rf" 2>&1
echo -en "FTP 서비스가 비활성화 되어 있거나, 활성화 시 root 계정 접속을 차단한 경우\t" >> "$rf" 2>&1

# FTP 서비스 포트 번호 확인
ftp_port=$(grep "^ftp " /etc/services | awk '{print $2}' | sed 's#/.*##' | uniq)

# FTP 서비스의 포트 활성화 여부 확인
if ! ss -tuln | grep -q ":$ftp_port "; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"FTP\" 데몬이 비활성화 되어 있는 상태입니다." >> "$rf" 2>&1
else
    # FTP 계정의 nologin 또는 /bin/false 설정 확인
    if grep -E "^ftp:" /etc/passwd | grep -E "(nologin|/bin/false)$"; then
        echo -en "[양호]\t" >> "$rf" 2>&1
        echo "\"FTP\" 기본 계정의 로그인이 불가능하게 설정되어 있는 상태입니다." >> "$rf" 2>&1
    else
        # ftpusers 파일 경로
        ftpusers_file="/etc/ftpusers"
    
        # 파일 존재 여부와 root 계정 포함 여부 검사
        if [ -f "$ftpusers_file" ]; then
            if grep -qw "^root$" "$ftpusers_file"; then
                echo -en "[양호]\t" >> "$rf" 2>&1
                echo "FTP 서비스 활성화 시 root 계정 접속이 차단되어 있는 상태입니다." >> "$rf" 2>&1
            else
                echo -en "[취약]\t" >> "$rf" 2>&1
                echo -en "FTP 서비스가 활성화 되어 있고, root 계정 접속을 허용하도록 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
				echo "주요정보통신기반시설 가이드를 참고하시어 ftpusers 파일에 root 계정을 추가하여 주시기 바랍니다. " >> "$rf" 2>&1
            fi
        else
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo "ftpusers 파일이 존재하지 않습니다." >> "$rf" 2>&1
        fi
    fi
fi

