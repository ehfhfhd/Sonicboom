#!/bin/bash

rf="/root/test_1/result_31"

U_31() {
    echo -en "U-31(상)\t3. 서비스  관리\t3.13 스팸 메일 릴레이 제한\t" >> $rf 2>&1
    echo -en "SMTP 서버의 릴레이 기능 제한 여부 점검\t" >> $rf 2>&1

    # SMTP 서비스가 활성화되어 있는지 확인
    if netstat -tln | grep -q ':25'; then
        # sendmail 파일이 있는지 확인
        if [ -n "$(find / -name 'sendmail.cf' -type f -exec grep -qi 'R$\*.*Relaying denied' {} +)" ]; then
            echo -en "[양호]\t" >> $rf 2>&1
            echo "릴레이 제한이 설정되어 있는 상태입니다." >> $rf 2>&1
        else
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "SMTP 서비스가 활성화되어 있으며 릴레이 제한이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 SMTP 서비스를 비활성화하거나 릴레이 제한을 설정하여 주시기 바랍니다." >> $rf 2>&1
        fi
    else
        # SMTP 서비스가 비활성화된 경우
        echo -en "[양호]\t" >> $rf 2>&1
        echo "SMTP 서비스가 비활성화 되어 있는 상태입니다." >> $rf 2>&1
    fi
}

U_31