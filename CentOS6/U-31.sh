U_31() {
    echo -en "U-31(상)\t3. 서비스  관리\t3.13 스팸 메일 릴레이 제한\t" >> $rf 2>&1
    echo -en "SMTP 서버의 릴레이 기능 제한 여부 점검\t" >> $rf 2>&1

    smtp_port_count=$(netstat -ntl | grep ':25 ' | wc -l)
    
    # SMTP 서비스가 활성화되어 있는 경우
    if [ $smtp_port_count -gt 0 ]; then
        relay_restrictions=$(grep -Ei 'smtpd_recipient_restrictions' /etc/postfix/main.cf | grep -vE '^#')
        if [ -z "$relay_restrictions" ]; then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "SMTP 서비스가 활성화되어 있으며 릴레이 제한이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 SMTP 서비스를 비활성화하거나 릴레이 제한을 설정하여 주시기 바랍니다." >> $rf 2>&1
        else
            echo -en "[양호]\t" >> $rf 2>&1
            echo "릴레이 제한이 설정되어 있는 상태입니다." >> $rf 2>&1
        fi

    # SMTP 서비스가 비활성화되어 있는 경우
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "SMTP 서비스가 비활성화 되어 있는 상태입니다." >> $rf 2>&1
    fi
}