#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-39(상)\t3. 서비스관리\t3.21 Apache 링크 사용 금지\t" >> "$rf" 2>&1
echo -en "심볼릭 링크, aliases 사용을 제한한 경우\t" >> "$rf" 2>&1

# 진단 수행 파일 목록
cf=()
cf=("/etc/httpd/conf/httpd.conf" "/etc/httpd/conf.d/*.conf")

# 발견된 취약한 설정 파일 목록을 저장할 배열
declare -a vulnerable_files

# Apache 서비스 구동 여부 확인
if ! pgrep -x "httpd" > /dev/null; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"Apache\" 데몬이 비활성화되어 있는 상태입니다." >> "$rf" 2>&1
else
    for file in ${cf[@]}; do
        if sudo test -f "$file"; then
            # 실제로 적용된 'FollowSymLinks' 설정 확인
            if sudo grep -E "^\s*Options" "$file" | grep "FollowSymLinks" | grep -vE "^\s*#" > /dev/null; then
                vulnerable_files+=("$file")
            fi
        fi
    done

    if [ ${#vulnerable_files[@]} -gt 0 ]; then
        echo -en "[취약]\t" >> "$rf" 2>&1
        for vf in "${vulnerable_files[@]}"; do
            echo -en "$vf에 \"FollowSymLinks\" 옵션이 활성화되어 있는 상태입니다.\t" >> "$rf" 2>&1
        done
        echo "주요정보통신기반시설 가이드를 참고하시어 각 파일의 옵션에서 \"-FollowSymLinks\"로 설정하시거나 제거하여 주시기 바랍니다." >> "$rf" 2>&1
    else
        echo -en "[양호]\t" >> "$rf" 2>&1
        echo "FollowSymLinks 옵션이 비활성화되어 있는 상태입니다." >> "$rf" 2>&1
    fi
fi

