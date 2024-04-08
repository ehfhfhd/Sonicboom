U_47() {
    echo -en "U-47(중)\t 1. 계정관리\t 1.8 패스워드 최대 사용기간 설정\t"  >> $rf 2>&1
    echo -en "시스템 정책에 패스워드 최대(90일 이하) 사용기간 설정이 적용되어 있는지 점검\t" >> $rf 2>&1

    if [ -f /etc/login.defs ]; then
        maxdays=$(awk '!/^\s*#/ &&/^\s*PASS_MAX_DAYS/{print $2}' /etc/login.defs)
        if [ -n "$maxdays" ] && [ "$maxdays" -le 90 ]; then
            echo -en "[양호]\t" >> $rf 2>&1
            echo "/etc/logins.defs 파일에 패스워드 최대 사용기간이 $maxdays 로 설정되어 있는 상태입니다." >> $rf 2>&1
        else
            echo -en "[취약]\t" >> $rf 2>&1
            if [ -z "$maxdays" ]; then
                echo -en "/etc/login.defs 파일에 패스워드 최대 사용기간이 설정되어 있지 않은 상태입니다." >> $rf 2>&1
            else
                echo -en "/etc/login.defs 파일에서 패스워드 최대 사용기간이 $maxdays 로 설정되어 있는 상태입니다.\t" >> $rf 2>&1
            echo "주요통신기반시설 가이드를 참고하여 /etc/login.defs 파일의 패스워드 최대 사용기간을 90일 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
            fi
        fi
    else
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "/etc/login.defs 파일이 존재하지 않습니다.\t" >> $rf 2>&1
        echo "주요통신기반시설 가이드를 참고하여 /etc/login.defs 파일의 패스워드 최대 사용기간을 90일 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
    fi
}
U_47