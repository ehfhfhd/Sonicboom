#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-38(상)\t3. 서비스관리\t3.20 Apache 불필요한 파일 제거\t" >> "$rf" 2>&1
echo -en "기본으로 생성되는 불필요한 파일 및 디렉토리가 제거되어 있는 경우\t" >> "$rf" 2>&1

# 진단 수행 경로
cf=()
cf=("/etc/httpd/*" "/var/www/*")

# Apache 서비스 구동 여부 확인
if ! pgrep -x "httpd" > /dev/null; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"Apache\" 데몬이 비활성화되어 있는 상태입니다." >> "$rf" 2>&1
else
    # "manual" 또는 "htdocs" 이름을 가진 파일 또는 디렉토리 검사
    declare -a vuln_files
    while IFS= read -r line; do
        vuln_files+=("$line")
    done < <(find ${cf[@]} -type f \( -name "manual" -o -name "htdocs" \))

    if [ ${#vuln_files[@]} -gt 0 ]; then
        echo -en "[취약]\t" >> "$rf" 2>&1
        for vf in "${vuln_files[@]}"; do
            echo -en "$vf 파일 또는 디렉토리가 존재하고 있는 상태입니다.\t" >> "$rf" 2>&1
        done
        echo "주요정보통신기반시설 가이드를 참고하시어 해당 파일들을 제거하여 주시기 바랍니다." >> "$rf" 2>&1
    else
        echo -en "[양호]\t" >> "$rf" 2>&1
        echo "Apache 설치 디렉터리 및 웹 Source 디렉터리 내 불필요한 파일이 존재하지 않는 상태입니다." >> "$rf" 2>&1
    fi
fi

