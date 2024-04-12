U_32() {
    echo -en "U-32(상)\t3. 서비스  관리\t3.14 일반사용자의 Sendmail 실행 방지\t" >> $rf 2>&1
    echo -en "SMTP 서비스 사용 시 일반사용자의 q 옵션 제한 여부 점검\t" >> $rf 2>&1

    # SMTP 서비스가 활성화되어 있는지 확인
    if netstat -tuln | grep -q ':25'; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "SMTP 서비스가 활성화 되어 있는 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 SMTP 서비스를 비활성화하여 주시기 바랍니다." >> $rf 2>&1
        return 0
    fi

    # Sendmail 설정 파일이 있는지 확인
    if [ -n "$(find / -name 'sendmail.cf' -type f 2>/dev/null)" ]; then
        sendmailcf_files=$(find / -name 'sendmail.cf' -type f 2>/dev/null)
        for file in $sendmailcf_files; do
            # restrictqrun 옵션이 있는지 확인
            if ! grep -q 'restrictqrun' "$file"; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo "$file 파일에 restrictqrun 옵션이 설정되어 있지 않은 상태입니다." >> $rf 2>&1
                return 0
            fi
        done
    else
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "Sendmail 서비스가 비활성되어 있는 상태입니다." >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 Sendmail 서비스를 활성화하여 주시기 바랍니다." >> $rf 2>&1
        return 0
    fi

    echo -en "[양호]\t" >> $rf 2>&1
    echo "SMTP 서비스 비활성화 또는 일반 사용자의 Sendmail 실행 방지가 활성화되어 있는 상태입니다." >> $rf 2>&1
}