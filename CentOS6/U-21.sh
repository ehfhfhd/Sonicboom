#!/bin/bash

rf="/root/test_1/result_21"

U_21() {
    echo -en "U-21(상)\t3. 서비스  관리\t3.3 r계열 서비스 비활성화\t" >> $rf 2>&1
    echo -en "r-command 서비스 비활성화 여부 점검\t" >> $rf 2>&1

    r_services=("rsh" "rlogin" "rexec")

    is_secure=true
    is_vulnerable=true

    for service in "${r_services[@]}"; do
        service_status=$(chkconfig --list | grep "$service" | awk '{print $5}')
        if [[ "$service_status" == "on" ]]; then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "$service 서비스가 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
            if netstat -tuln | grep -q "$service"; then
                if $is_vulnerable; then
                    echo -en "[취약]\t" >> $rf 2>&1
                    echo "주요정보통신기반시설 가이드를 참고하시어 $service 서비스를 비활성화하세요. chkconfig $service off" >> $rf 2>&1
                    is_vulnerable=false
                fi
            fi
            is_secure=false
        else
            if $is_secure; then
                echo -en "[양호]\t" >> $rf 2>&1
                echo "불필요한 r계열 서비스가 비활성화되어 있는 상태입니다." >> $rf 2>&1
                is_secure=false
            fi
        fi
    done
}

U_21