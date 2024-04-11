#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-63(하)\t3. 서비스관리\t3.27 FTP 접근제어 파일 소유자 및 권한 설정\t" >> "$rf" 2>&1
echo -en "ftpusers 파일 소유자가 root이고, 권한이 640 이하인 경우\t" >> "$rf" 2>&1

# FTP 서비스 포트 번호 확인
ftp_port=$(grep "^ftp " /etc/services | awk '{print $2}' | sed 's#/.*##' | uniq)

# FTP 서비스의 포트 활성화 여부 확인
if ! ss -tuln | grep -q ":$ftp_port " ; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"FTP\" 데몬이 비활성화 되어 있는 상태입니다." >> "$rf" 2>&1
else
    # ftpusers 파일 검사 진행
    ftpusers_file="/etc/ftpusers"
    if [ -f "$ftpusers_file" ]; then
        file_owner=$(stat -c "%U" "$ftpusers_file")
        file_perms=$(stat -c "%a" "$ftpusers_file")
        
        # 파일 소유자 및 권한 검사
        if [ "$file_owner" != "root" ]; then
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo -en "파일의 소유자가 $file_owner로 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
        	echo "주요정보통신기반시설 가이드를 참고하시어 파일의 소유자를 \"root\"로 설정하여 주시기 바랍니다." >> "$rf" 2>&1
		else
            perms_correct=true
            read_perm="${file_perms:0:1}"
            write_perm="${file_perms:1:1}"
            execute_perm="${file_perms:2:1}"
            
            if [[ "$read_perm" -gt 6 ]]; then perms_correct=false; fi
            if [[ "$write_perm" -gt 4 ]]; then perms_correct=false; fi
            if [[ "$execute_perm" -gt 0 ]]; then perms_correct=false; fi
            
            if $perms_correct; then
                echo -en "[양호]\t" >> "$rf" 2>&1
				echo "ftpusers 파일 소유자가 root이고, 권한이 ${file_perms}으로 설정되어 있는 상태입니다. " >> "$rf" 2>&1
            else
                echo -en "[취약]\t" >> "$rf" 2>&1
                echo -en "ftpusers 파일의 권한이 ${file_perms}으로 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
				echo "주요정보통신기반시설 가이드를 참고하시어 파일의 권한을 640 이하로 설정하여 주시기 바랍니다."
            fi
        fi
    else
        echo -en "[취약]\t" >> "$rf" 2>&1
        echo "ftpusers 파일이 존재하지 않습니다." >> "$rf" 2>&1
    fi
fi

