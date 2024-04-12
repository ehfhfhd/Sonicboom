#!/bin/bash

rf="/root/test_1/result_29"

U_29() {
    echo -en "U-29(상)\t3. 서비스  관리\t3.11 tftp, talk 서비스 비활성화\t" >> $rf 2>&1
    echo -en "tftp, talk 등의 서비스를 사용하지 않거나 취약점이 발표된 서비스의 활성화 여부 점검\t" >> $rf 2>&1

    services=("tftp" "talk" "ntalk")

    # 서비스가 활성화 되어 있는지 확인
    for service in "${services[@]}"; do
        ps_output=$(ps -ef | grep -v grep | grep "$service")
        if [ -n "$ps_output" ]; then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "$service 서비스가 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 $service 서비스를 비활성화 해주시기 바랍니다." >> $rf 2>&1
            return 0
        fi
    done

    # 모든 서비스가 비활성화 되어 있는지 확인
    echo -en "[양호]\t" >> $rf 2>&1
    echo "tftp, talk, ntalk 서비스가 모두 비활성화되어 있는 상태입니다." >> $rf 2>&1
    return 0
}

U_29