#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-40(상)\t3. 서비스관리\t3.22 Apache 파일 업로드 및 다운로드 제한\t" >> "$rf" 2>&1
echo -en "파일 업로드 및 다운로드를 제한한 경우\t" >> "$rf" 2>&1

# 진단 수행 파일 목록
cf=()
cf=("/etc/httpd/conf/httpd.conf" "/etc/httpd/conf.d/*.conf")

# Apache 서비스 구동 여부 확인
if ! pgrep -x "httpd" > /dev/null; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"Apache\" 데몬이 비활성화되어 있는 상태입니다." >> "$rf" 2>&1
else
    limit_set=false
    for file in ${cf[@]}; do
        if sudo test -f "$file"; then
            # LimitRequestBody 설정 확인
            if sudo grep -E "^\s*LimitRequestBody" "$file" | grep -vE "^\s*#" > /dev/null; then
                limit_value=$(sudo grep -E "^\s*LimitRequestBody" "$file" | grep -vE "^\s*#" | awk '{print $2}')
                # 파일 업로드 및 다운로드 제한이 설정되어 있는지 확인
                if [[ "$limit_value" != "" ]] && [[ "$limit_value" -gt 0 ]]; then
                    limit_set=true
                    echo -en "[양호]\t" >> "$rf" 2>&1
                    echo "\"LimitRequestBody\"옵션이 설정되어 있는 상태입니다." >> "$rf" 2>&1
                    break
                fi
            fi
        fi
    done
    if ! $limit_set; then
        echo -en "[취약]\t" >> "$rf" 2>&1
        echo -en "$file에\"LimitRequestBody\"옵션이 설정되어 있지 않은 상태입니다.\t" >> "$rf" 2>&1
		echo "주요정보통신기반가이드를 참고하시어 \"LimitRequestBody\"옵션을 설정하여 주시기 바랍니다." >> "$rf" 2>&1
    fi
fi

