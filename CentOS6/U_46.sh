U_46() {
    echo -en "U-46(중)\t 1. 계정관리\t 1.7 패스워드 최소 길이 설정\t"  >> $rf 2>&1
    echo -en "시스템 정책에 패스워드 최소(8자 이상) 길이 설정이 적용되어 있는 점검\t" >> $rf 2>&1

    if [ -f /etc/login.defs ]; then
        minlen=$(awk '!/^\s*#/ && /^\s*PASS_MIN_LEN/{print $2}' /etc/login.defs) >> $rf 2>&1
        if [ -n "$minlen" ] && [ "$minlen" -ge 8 ]; then
            echo -en "[양호]\t" >> $rf 2>&1
            echo " /etc/login.defs파일에 패스워드 최소 길이가 8자 이상으로 설정되어 있는 상태입니다." >> $rf 2>&1
        else
            echo -en "[취약]\t" >> $rf 2>&1
            if [ -z "$minlen" ]; then
                echo -en "%s 파일에 패스워드 최소 길이가 설정되어 있지 않습니다.\t" >> $rf 2>&1
            else
                echo -en "/etc/login.defs 파일에 패스워드 최소 길이가 $minlen 로 설정되어 있는 상태입니다.\t">> $rf 2>&1
                echo "주요통신기반시설 가이드를 참고하시어 "/etc/login.defs"파일 내 패스워드 최소 자리수를 "8"이상으로 설정하여 주시기 바랍니다." >> $rf 2>&1
            fi
        fi
    else
        echo -en "[취약]\t" >> $rf 2>&1
        echo "/etc/login.defs 파일이 존재하지 않습니다." >> $rf 2>&1
    fi
}
U_46