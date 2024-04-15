U_31() {
    echo -en "U-31(상)\t3. 서비스  관리\t3.13 스팸 메일 릴레이 제한\t" >> $rf 2>&1
    echo -en "SMTP 서버의 릴레이 기능 제한 여부 점검\t" >> $rf 2>&1

    smtp_port_count=$(netstat -ntl | grep ':25 ' | wc -l)
    
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
            # sendmail.cf 파일에서 릴레이 제한 설정 확인
            relaying_denied=$(grep -vE '^#|^\s#' "$file" | grep -i 'R$\*' | grep -i 'Relaying denied')
            if [[ -z "$relaying_denied" ]]; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "SMTP 서비스가 활성화되어 있으며 릴레이 제한이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 $file 파일에 릴레이 제한이 설정하여 주시기 바랍니다." >> $rf 2>&1
                return 0
            fi
        done
    fi

    echo -en "[양호]\t" >> $rf 2>&1
    echo "SMTP 서비스가 비활성화 되어 있는 상태입니다." >> $rf 2>&1
    return 0
}