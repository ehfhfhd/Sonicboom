#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-37(상)\t3. 서비스관리\t3.19 Apache 상위 디렉토리 접근 금지\t" >> "$rf" 2>&1
echo -en "상위 디렉토리에 이동제한을 설정한 경우\t" >> "$rf" 2>&1

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
            # AllowOverride 설정값 확인
            if sudo grep -E "^\s*AllowOverride" "$file" | grep -E "(None|AuthConfig|All)" | grep -vE "^\s*#" > /dev/null; then
                vulnerable_files+=("$file")
            fi
        fi
    done
    if [ ${#vulnerable_files[@]} -gt 0 ]; then
        echo -en "[취약]\t" >> "$rf" 2>&1
        for vf in "${vulnerable_files[@]}"; do
            echo -en "$vf에 상위 디렉토리 접근 제한이 설정되어 있지 않은 상태입니다.\t" >> "$rf" 2>&1
        done
        echo "주요정보통신기반시설 가이드를 참고하시어 \"AllowOverride\" 값을 \"AuthConfig\" 또는 \"All\"로 설정하여 주시기 바랍니다." >> "$rf" 2>&1
    else
        echo -en "[양호]\t" >> "$rf" 2>&1
        echo "상위 디렉토리 접근 제한이 적절하게 설정되어 있는 상태입니다." >> "$rf" 2>&1
    fi
fi

