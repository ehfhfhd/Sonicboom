U_03() {
    echo -en "U-03(상)\t 1. 계정관리\t 1.3 계정 잠금 임계값 설정\t" >> $rf 2>&1
    echo -en "시스템 정책에 사용자 로그인 실패 임계값이 설정되어 있는지 점검\t" >> $rf 2>&1

    system_auth_file="/etc/pam.d/system-auth"

    # 파일 존재 여부 확인
    if [ ! -f "$system_auth_file" ]; then
        echo -en "[취약]\t" >>  $rf 2>&1
        echo -en "시스템에 /etc/pam.d/system-auth 파일이 존재하지 않는 상태입니다.\t"  >>  $rf 2>&1
        echo "주요통신기반시설 가이드를 참고하시어 "/etc/pam.d/system-auth" 설정 파일 내 패스워드 잠금 임계값을 "5" 이하, 잠금시간을 "3600" 이하로 설정하여 주시기 바랍니다." >>  $rf 2>&1
    else
        min_fail=$(grep -E '^auth.*required.*pam_faillock.so' "$system_auth_file" | grep -E 'deny=[0-9]+' | grep -oE 'deny=[0-9]+' | cut -d'=' -f2)
        lock_time=$(grep -E '^auth.*required.*pam_faillock.so' "$system_auth_file" | grep -E 'unlock_time=[0-9]+' | grep -oE 'unlock_time=[0-9]+' | cut -d'=' -f2)

        if [ -z "$min_fail" ] || [ -z "$lock_time" ]; then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "/etc/pam.d/system-auth 파일에 계정 잠금 임계값 또는 잠금시간이 설정되어 있지 않습니다." >> $rf 2>&1
            echo "주요통신기반시설 가이드를 참고하시어 "/etc/pam.d/system-auth" 설정 파일 내 패스워드 잠금 임계값을 "5" 이하, 잠금시간을 "3600" 이하로 설정하여 주시기 바랍니다." >>  $rf 2>&1
        else
            if [ "$min_fail" -gt 5 ] && [ "$lock_time" -gt 3600 ]; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "계정 잠금 임계값은 $min_fail, 잠금시간은 $lock_time 인 상태입니다.\t" >> $rf 2>&1
                echo "주요통신기반시설 가이드를 참고하시어 "/etc/pam.d/system-auth" 설정 파일 내 패스워드 잠금 임계값을 "5" 이하, 잠금시간을 "3600" 이하로 설정하여 주시기 바랍니다." >>  $rf 2>&1
            elif [ "$min_fail" -le 5 ] && [ "$lock_time" -gt 3600 ]; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "계정 잠금 임계값은 $min_fail, 잠금시간은 $lock_time 인 상태입니다.\t" >> $rf 2>&1
                echo "주요통신기반시설 가이드를 참고하시어 "/etc/pam.d/system-auth" 설정 파일 내 잠금시간을 "3600" 이하로 설정하여 주시기 바랍니다." >>  $rf 2>&1
            elif [ "$min_fail" -gt 5 ] && [ "$lock_time" -le 3600 ]; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "계정 잠금 임계값은 $min_fail, 잠금시간은 $lock_time 인 상태입니다.\t" >> $rf 2>&1
                echo "주요통신기반시설 가이드를 참고하시어 "/etc/pam.d/system-auth" 설정 파일 내 패스워드 잠금 임계값을 "5" 이하로 설정하여 주시기 바랍니다." >>  $rf 2>&1
            else
                echo -en "[양호]\t" >> $rf 2>&1
                echo "/etc/pam.d/system-auth 파일에 계정 잠금 임계값이 $min_fail, 잠금시간이 $lock_time 로 설정되어 있는 상태입니다." >> $rf 2>&1
            fi
        fi
    fi
}
U_03