#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-71(중)\t3. 서비스관리\t3.35 Apache 웹 서비스 정보 숨김\t" >> "$rf" 2>&1
echo -en "ServerTokens Prod, ServerSignature Off로 설정되어있는 경우\t" >> "$rf" 2>&1

# Apache 서비스 구동 여부 확인
if ! pgrep -x "httpd" > /dev/null; then
    # Apache 서비스가 비활성화되어 있는 경우
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"Apache\" 데몬이  비활성화되어 있는 상태입니다." >> "$rf" 2>&1
else
    # Apache가 실행 중인 경우, 추가 진단 수행
    cf=("/etc/httpd/conf/httpd.conf" "/etc/httpd/conf.d/*.conf")
    server_tokens_status="Not Set"
    server_signature_status="Not Set"

    for file in ${cf[@]}; do
        if [ -f "$file" ]; then
            # ServerTokens 설정 추출
            st=$(grep -Ei "^\s*ServerTokens" "$file" | awk '{print $2}' | tail -1)
            server_tokens_status=${st:-$server_tokens_status}

            # ServerSignature 설정 추출
            ss=$(grep -Ei "^\s*ServerSignature" "$file" | awk '{print $2}' | tail -1)
            server_signature_status=${ss:-$server_signature_status}
        fi
    done

    # 조건 확인 후 상태 출력
    if [[ "$server_tokens_status" == "Prod" && "$server_signature_status" == "Off" ]]; then
        # 양호한 설정 상태
        echo -en "[양호]\t" >> "$rf" 2>&1
        echo "\"ServerTokens\" 값이 \"Prod\", \"ServerSignature\" 값이 \"Off\"로 적절히 설정되어 있는 상태입니다." >> "$rf" 2>&1
    else
        # 취약한 설정 상태
        echo -en "[취약]\t" >> "$rf" 2>&1
        echo -en "\"ServerTokens\" 값이 \"$server_tokens_status\", \"ServerSignature\" 값이 \"$server_signature_status\"으로 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 \"ServerTokens\" 값을 \"Prod\", \"ServerSignature\" 값을 \"Off\"로 설정하여 주시기 바랍니다." >> "$rf" 2>&1
    fi
fi

