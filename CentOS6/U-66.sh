#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-66(중)\t3. 서비스관리\t3.30 SNMP 서비스 구동 점검\t" >> "$rf" 2>&1
echo -en "SNMP 서비스를 사용하지 않는 경우\t" >> "$rf" 2>&1

# SNMP 데몬 이름
snmp_daemons=("snmpd" "snmptrapd")

# SNMP 데몬 활성화 여부 확인
snmp_active=false
for daemon in "${snmp_daemons[@]}"; do
    if ps -a | grep -qw "$daemon"; then
        snmp_active=true
        break
    fi
done

if $snmp_active; then
    echo -en "[취약]\t" >> "$rf" 2>&1
    echo -en "SNMP 서비스가 활성화되어 있는 상태입니다. \t" >> "$rf" 2>&1
	echo "주요정보통신기반시설 가이드를 참고하시어 SNMP 서비스를 비활성화하여 주시기 바랍니다." >> "$rf" 2>&1
	echo "부득이 해당 기능을 활용해야 하는 경우 기본 Community String 변경, 네트워크 모니터링 등의 보안 조치를 반드시 적용하여주시기 바랍니다." >> "$rf" 2>&1
else
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"SNMP\" 데몬이 비활성화 되어 있는 상태입니다. " >> "$rf" 2>&1
fi

