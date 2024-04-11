#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-36(상)\t3. 서비스관리\t3.18 Apache 웹 프로세스 권한 제한\t" >> "$rf" 2>&1
echo -en "Apache 데몬이 root 권한으로 구동되지 않는 경우\t" >> "$rf" 2>&1

# 진단 수행 파일 목록
cf=()
cf=("/etc/httpd/conf/httpd.conf" "/etc/httpd/conf.d/*.conf")

# 발견된 취약한 파일 목록을 저장할 배열 선언
declare -a vulnerable_files

# Apache 서비스 구동 여부 확인
if ! pgrep -x "httpd" > /dev/null; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"Apache\" 데몬이 비활성화되어 있는 상태입니다." >> "$rf" 2>&1
else
    for file in ${cf[@]}; do
        if sudo test -f "$file"; then
            # User와 Group 설정 추출 및 확인
            user=$(sudo grep -E "^\s*User" "$file" | grep -v "#" | awk '{print $2}')
            group=$(sudo grep -E "^\s*Group" "$file" | grep -v "#" | awk '{print $2}')
            if [ "$user" == "root" ] || [ "$group" == "root" ]; then
                vulnerable_files+=("$file")
            fi
        fi
    done
    if [ ${#vulnerable_files[@]} -gt 0 ]; then
        echo -en "[취약]\t" >> "$rf" 2>&1
        for vf in "${vulnerable_files[@]}"; do
            echo -en "\"Apache\" 데몬이 root 계정으로 구동되고 있는 상태입니다.\t" >> "$rf" 2>&1
        done
        echo "주요정보통신기반시설 가이드를 참고하시어 \"Apache\" 데몬이 전용 계정으로 구동되도록 설정하여주시기 바랍니다." >> "$rf" 2>&1
    else
        echo -en "[양호]\t" >> "$rf" 2>&1
        echo "\"Apache\"데몬이 전용 계정으로 구동되고 있는 상태입니다." >> "$rf" 2>&1
    fi
fi

