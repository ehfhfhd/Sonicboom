U_72() {
	echo -en "U-72(하)\t 5. 로그 관리\t 5.2 정책에 따른 시스템 로깅 설정\t"  >> $rf 2>&1
	echo -en "내부 정책에 따른 시스템 로깅 설정 적용 여부 점검\t" >> $rf 2>&1

    rsyslog_conf="/etc/rsyslog.conf"

    if [ `ps -ef | grep 'syslog' | grep -v 'grep' | wc -l` -eq 0 ]; then
        echo -en "[양호]\t" >> $rf 2>&1
        echo "syslog 서비스가 구동중이지 않는 상태입니다." >> $rf 2>&1 
    else
        if [ -f /etc/rsyslog.conf ];then
            if [ `cat /etc/rsyslog.conf | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]; then
                echo -en "[양호]\t" >> $rf 2>&1
                echo -en "/etc/rsyslog.conf 파일에 다음과 같은 설정내용이 포함되어 있는 상태입니다.\t" >> $rf 2>&1
                cat /etc/rsyslog.conf | grep -v "^#" | grep -v "^ *$" >> $rf 2>&1
            else
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "/etc/rsyslog.conf 파일에 설정 내용이 없는 상태입니다. \t" >> $rf 2>&1 
                echo "주요통신기반시설 가이드를 참고하시어 /etc/rsyslog.conf 파일을 설정하여 주시기 바랍니다." >> $rf 2>&1
            fi
        else
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "/etc/rsyslog.conf 파일이 존재하지 않는 상태입니다.\t" >> $rf 2>&1
            echo "주요통신기반시설 가이드를 참고하시어 /etc/rsyslog.conf 파일을 설정하여 주시기 바랍니다." >> $rf 2>&1
        fi
    fi
}
U_72