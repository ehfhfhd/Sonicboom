U_19() {
    echo -en "U-19(상)\t3. 서비스 관리\t3.1 Finger 서비스 비활성화\t" >> $rf 2>&1
    echo -en "finger 서비스 비활성화 여부 점검\t" >> $rf 2>&1

    # /etc/services 파일 확인
    if [ grep -q '^finger\s' /etc/services ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "Finger 서비스가 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 /etc/services 파일에서 해당 서비스를 주석 처리 또는 삭제하여 주시길 바랍니다." >> $rf 2>&1
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "Finger 서비스가 비활성화되어 있는 상태입니다." >> $rf 2>&1
    fi

    # xinetd 설정 파일 확인
    if [ grep -q '^service\s+finger' /etc/xinetd.d/* ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "Finger 서비스가 xinetd를 통해 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 xinetd 설정 파일에서 해당 서비스를 주석 처리 또는 삭제 후, xinetd를 재시작하여 주시길 바랍니다." >> $rf 2>&1
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "Finger 서비스가 xinetd를 통해 비활성화되어 있는 상태입니다." >> $rf 2>&1
    fi

    # inetd 설정 파일 확인
    if [ grep -q '^finger\s' /etc/inetd.conf ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "Finger 서비스가 inetd를 통해 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 inetd 설정 파일에서 해당 서비스를 주석 처리 또는 삭제 후, inetd를 재시작하여 주시길 바랍니다." >> $rf 2>&1
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "Finger 서비스가 inetd를 통해 비활성화되어 있는 상태입니다." >> $rf 2>&1
    fi
}