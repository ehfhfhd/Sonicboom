U_54() {
	echo -en "U-54(하)\t 1. 계정관리\t 1.15 Session Timeout 설정\t"  >> $rf 2>&1
	echo -en "사용자 쉘에 대한 환경설정 파일에서 session timeout 설정 여부 점검\t" >> $rf 2>&1

    tmout_value=$(grep -E '^TMOUT=' /etc/profile | awk -F '=' '{print $2}')

    if [ -z "$tmout_value" ]; then
        echo -en "[취약]\t">> $rf 2>&1
        echo -en "Session Timeout값이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 "Session Timeout" 값을 "600" 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
    else
        if [ "$tmout_value" -le 600 ]; then            
            echo -en "[양호]\t">> $rf 2>&1
            echo "Session Timeout값이 $tmout_value 인 상태입니다.">> $rf 2>&1
        else
            echo -en "[취약]\t">> $rf 2>&1
            echo -en "Session Timeout값이 $tmout_value 인 상태입니다.\t">> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 "Session Timeout" 값을 "600" 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
        fi
    fi
}
U_54