#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-67(중)\t3. 서비스관리\t3.31 SNMP 서비스 Community String의 복잡성 설정\t" >> "$rf" 2>&1
echo -en "SNMP Community 이름이 public, private 이 아닌 경우\t" >> "$rf" 2>&1

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

# SNMP 데몬이 구동 중이지 않으면 양호
if ! $snmp_active; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"SNMP\" 데몬이 비활성화 되어 있는 상태입니다." >> "$rf" 2>&1
else
    # snmpd.conf 파일을 시스템 전체에서 찾기
    while IFS= read -r conf_file; do
        # public 또는 private 문자열 검사
        grep -Eq "^\s*com2sec.*\s(public|private)\s" "$conf_file"
        if [ $? -eq 0 ]; then
            # 커뮤니티명이 public 또는 private으로 설정된 경우
            community_name=$(grep -Eo "(public|private)" "$conf_file" | uniq)
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo -en "SNMP community 이름이 $community_name으로 설정되어 있습니다.\t" >> "$rf" 2>&1
            echo -n "주요정보통신기반시설 가이드를 참고하시어 해당 파일에서 커뮤니티명을 추측하기 어려운 값으로 변경하여 주시기 바랍니다." >> "$rf" 2>&1
        fi
    done < <(find / -type f -name 'snmpd.conf' 2>/dev/null)
fi

