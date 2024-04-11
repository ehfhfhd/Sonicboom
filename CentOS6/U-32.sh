#!/bin/bash

rf="/root/test_1/result_32"

U_32() {
    echo -en "U-32(상)\t3. 서비스  관리\t3.14 일반사용자의 Sendmail 실행 방지\t" >> $rf 2>&1
    echo -en "SMTP 서비스 사용 시 일반사용자의 q 옵션 제한 여부 점검\t" >> $rf 2>&1

    # SMTP 서비스가 활성화되어 있는지 확인
    smtp_active=false
    if [ "$(netstat -tuln | grep -c ':25')" -gt 0 ]; then
        smtp_active=true
    fi

    sendmail_running=false
    if ps -ef | grep -q '/sendmail'; then
        sendmail_running=true
        /etc/init.d/sendmail stop
    fi

    chkconfig sendmail off

    # sendmail의 실행 권한 확인 및 제한
    sendmail_restricted=false
    sendmail_binary=$(which sendmail)
    if [ -n "$sendmail_binary" ]; then
        permissions=$(ls -l $sendmail_binary)
        if [[ $permissions != *"-rwxr-x---"* ]]; then
            chmod 750 $sendmail_binary
            setfacl -m u::x,g::x,o:- $sendmail_binary
        else
            sendmail_restricted=true
        fi
    fi

    restrictqrun_set=false
    sendmail_config="/etc/mail/sendmail.cf"
    if grep -q "O QueueLA=75,QueueFactor=100" $sendmail_config; then
        restrictqrun_set=true
    fi


    if [ "$smtp_active" = false ] || [ "$sendmail_restricted" = true ]; then
        echo -en "[양호]\t" >> $rf 2>&1
        echo "SMTP 서비스 비활성화 또는 일반 사용자의 Sendmail 실행 방지가 활성화되어 있는 상태입니다." >> $rf 2>&1
    else
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "SMTP 서비스 사용 및 일반 사용자의 Sendmail 실행 방지가 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 SMTP 서비스를 비활성화하거나, 일반 사용자의 Sendmail 실행 방지를 활성화하여 주시기 바랍니다." >> $rf 2>&1
    fi

}

U_32