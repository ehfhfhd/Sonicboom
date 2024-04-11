#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-70(중)\t3. 서비스관리\t3.34 expn, vrfy 명령어 제한\t" >> "$rf" 2>&1
echo -en "SMTP 서비스 미사용 또는, noexpn, novrfy 옵션이 설정되어 있는 경우\t" >> "$rf" 2>&1

# sendmail 데몬 활성화 여부 확인
if ! ps -a | grep -qw "sendmail"; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"SMTP\" 데몬이 비활성화되어 있는 상태입니다." >> "$rf" 2>&1
else
    # sendmail.cf 파일에서 expn, vrfy 명령어 제한 설정 확인
    sendmail_cf="/etc/mail/sendmail.cf"
    if [ -f "$sendmail_cf" ]; then
        privacy_options=$(grep "^O PrivacyOptions" "$sendmail_cf")
        if [[ "$privacy_options" == *"noexpn"* ]] && [[ "$privacy_options" == *"novrfy"* ]]; then
            echo -en "[양호]\t" >> "$rf" 2>&1
            echo "SMTP 서비스 설정파일에 noexpn, novrfy 옵션이 설정되어 있는 상태입니다." >> "$rf" 2>&1
        else
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo -en "SMTP 서비스 설정파일에 noexpn, novrfy 옵션이 설정되어 있지 않은 상태입니다.\t" >> "$rf" 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 noexpn, novrfy 옵션을 설정하여 주시기 바랍니다." >> "$rf" 2>&1
        fi
    else
        echo -en "[취약]\t" >> "$rf" 2>&1
        echo "SMTP 서비스 설정파일을 찾을 수 없습니다." >> "$rf" 2>&1
    fi
fi

