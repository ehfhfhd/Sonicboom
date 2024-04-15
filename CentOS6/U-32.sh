U_32() {
    echo -en "U-32(상)\t3. 서비스  관리\t3.14 일반사용자의 Sendmail 실행 방지\t" >> $rf 2>&1
    echo -en "SMTP 서비스 사용 시 일반사용자의 q 옵션 제한 여부 점검\t" >> $rf 2>&1

    # Sendmail 프로세스 확인
    ps_smtp_count=$(ps -ef | grep -iE 'smtp|sendmail' | grep -v 'grep' | wc -l)
    if [ $ps_smtp_count -gt 0 ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "SMTP 서비스가 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 SMTP 서비스를 비활성화 해주시기 바랍니다." >> $rf 2>&1
        return 0
    fi

    # Sendmail 설정 파일 확인
    sendmailcf_files=$(find / -name 'sendmail.cf' -type f 2>/dev/null)
    if [[ -n "$sendmailcf_files" ]]; then
        for file in $sendmailcf_files; do
            # sendmail.cf 파일에서 q 옵션 제한 확인
            restrictq=$(grep -vE '^#|^\s#' "$file" | awk '{gsub(" ", "", $0); print tolower($0)}' | awk -F 'q' '{print $2}' | grep -w 'r')
            if [[ -z "$restrictq" ]]; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "$file 파일에서 q 옵션 제한이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 일반 사용자의 Sendmail 실행 방지를 활성화하여 주시기 바랍니다." >> $rf 2>&1
                return 0
            fi
        done
    fi

    echo -en "[양호]\t" >> $rf 2>&1
    echo "SMTP 서비스 비활성화 또는 일반 사용자의 Sendmail 실행 방지가 활성화되어 있는 상태입니다." >> $rf 2>&1
    return 0
}