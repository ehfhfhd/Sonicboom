#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-60(중)\t3. 서비스관리\t3.24 ssh 원격접속 허용\t" >> "$rf" 2>&1
echo -en "원격 접속 시 SSH 프로토콜을 사용하는 경우\t" >> "$rf" 2>&1

# 안전하지 않은 서비스의 이름 목록
insecure_services=("telnet" "ftp")
declare -a active_insecure_services

# /etc/services 파일에서 서비스 이름을 기반으로 포트 번호 찾기
for service_name in "${insecure_services[@]}"; do
    if pgrep -x "$service_name" > /dev/null; then
        # 서비스가 실행 중인 경우, 해당 서비스의 포트 번호를 /etc/services에서 찾기
        port=$(grep "^$service_name " /etc/services | awk '{print $2}' | sed 's#/.*##' | uniq)
        if [ -n "$port" ] && ss -tuln | grep -q ":$port "; then
            active_insecure_services+=("$service_name")
        fi
    fi
done

# SSH 서비스 확인
ssh_active=false
if pgrep -x "sshd" > /dev/null; then
    ssh_active=true
fi

# 결과 출력
if $ssh_active && [ ${#active_insecure_services[@]} -eq 0 ]; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"SSH\"만 사용하도록 설정되어 있는 상태입니다." >> "$rf" 2>&1
else
    if [ ${#active_insecure_services[@]} -gt 0 ]; then
        echo -en "[취약]\t" >> "$rf" 2>&1
        for service in "${active_insecure_services[@]}"; do
            echo -en "\"$service\" 서비스가 실행되고 있는  상태입니다.\t" >> "$rf" 2>&1 
			echo "주요정보통신기반시설 가이드를 참고하시어 \"$service\" 서비스를 중단하여 주시기 바랍니다." >> "$rf" 2>&1
        done
    fi
fi

