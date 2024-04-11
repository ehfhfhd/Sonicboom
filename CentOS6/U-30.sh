U_30() {
    echo -en "U-30(상)\t3. 서비스  관리\t3.12 Sendmail 버전 점검\t" >> $rf 2>&1
    echo -en "취약한 버전의 Sendmail 서비스 이용 여부 점검\t" >> $rf 2>&1

    # sendmail 서비스 실행 여부 확인
    sendmail_status=$(service sendmail status | grep "is running")

    # sendmail 버전 확인
    sendmail_version=$(sendmail -d0.1 < /dev/null 2>&1 | grep "Version" | awk '{print $2}')
    vulnerable_version="8.14.4"

    if [ -n "$sendmail_status" ]; then
        if [ -n "$sendmail_version" ]; then
            if [[ "$sendmail_version" == "$vulnerable_version" ]]; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "Sendmail 버전이 최신 버전이 아닌 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 Sendmail 버전을 최신 버전으로 설정하여 주시기 바랍니다." >> $rf 2>&1
            else
                echo -en "[양호]\t" >> $rf 2>&1
                echo "Sendmail 버전이 최신 버전인 상태입니다.\t" >> $rf 2>&1
            fi
        fi
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "Sendmail 데몬이 비활성화 되어 있는 상태입니다.\t" >> $rf 2>&1
    fi

}