#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-41(상)\t3. 서비스관리\t3.23 Apache 웹 서비스 영역의 분리\t" >> "$rf" 2>&1
echo -en "DocumentRoot를 별도의 디렉토리로 지정한 경우\t" >> "$rf" 2>&1

# 진단 수행 파일 목록
cf=()
cf=("/etc/httpd/conf/httpd.conf" "/etc/httpd/conf.d/*.conf")

# Apache 서비스 구동 여부 확인
if ! pgrep -x "httpd" > /dev/null; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"Apache\" 데몬이 비활성화되어 있는 상태입니다." >> "$rf" 2>&1
else
    document_root_set=false
    for file in ${cf[@]}; do
        if sudo test -f "$file"; then
            while IFS= read -r line; do
                document_root=$(echo "$line" | grep -oP '^DocumentRoot\s+"\K[^"]+')
                if [[ -n "$document_root" ]] && { [[ "$document_root" == "/usr/local/apache/htdocs" ]] || [[ "$document_root" == "/usr/local/apache2/htdocs" ]] || [[ "$document_root" == "/var/www/html" ]]; }; then
                    echo -en "[취약]\t" >> "$rf" 2>&1
                    echo -en "$file의 DocumentRoot가 기본 디렉토리($document_root)로 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
					echo "주요정보통신기반시설 가이드를 참고하시어 웹 Source 디렉터리를 유추할 수 없는 다른 경로로 설정하여 주시기 바랍니다." >> "$rf" 2>&1
                    document_root_set=true
                    break 2
                fi
            done < <(sudo grep "DocumentRoot" "$file" | grep -vE '^#')
        fi
    done
    if ! $document_root_set; then
        echo -en "[양호]\t" >> "$rf" 2>&1
        echo "모든 설정 파일에서 DocumentRoot가 별도의 디렉토리로 지정되어 있는 상태입니다." >> "$rf" 2>&1
    fi
fi

