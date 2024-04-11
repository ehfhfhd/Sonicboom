#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-68(하)\t3. 서비스관리\t3.32 로그온 시 경고 메시지 제공\t" >> "$rf" 2>&1
echo -en "서버 및 Telnet, FTP, SMTP, DNS 서비스에 로그온 메시지가 설정되어 있는 경우\t" >> "$rf" 2>&1

results=""
vulnerable=false

# 서비스 및 관련 파일 정의
declare -A services=(
    [Telnet]="/etc/issue.net"
    [FTP]="/etc/issue.net"
    [SMTP]="/etc/mail/sendmail.cf"
    [DNS]="/etc/issue.net"
)

# 각 서비스별 데몬 활성화 및 로그온 메시지 설정 점검
for service in "${!services[@]}"; do
    service_active=$(ps -a | grep -qw "$service" && echo "active" || echo "inactive")
    config_file=${services[$service]}
    
    if [ "$service_active" == "inactive" ]; then
        results+="\"$service\" 데몬이 비활성화되어 있는 상태입니다.\t"
    else
        if [ -f "$config_file" ] && grep -q "Banner" "$config_file"; then
            results+="\"$service\" 서비스에 로그온 메시지가 설정되어 있는 상태입니다.\t"
        else
            results+="\"$service\" 서비스에 로그온 메시지가 설정되어 있지 않은 상태입니다.\t"
            vulnerable=true
        fi
    fi
done

# 최종 결과 출력
if $vulnerable; then
    # 취약한 현황만 출력
    echo -en "[취약]\t" >> "$rf" 2>&1
    echo -e "${results//* 데몬이 비활성화되어 있는 상태입니다.\\t/}" >> "$rf" 2>&1  # 양호한 메시지 제거
else
    # 모든 양호한 현황 출력
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo -e "$results" >> "$rf" 2>&1
fi

