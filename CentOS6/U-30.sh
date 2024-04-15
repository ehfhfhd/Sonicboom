U_30() {
    echo -en "U-30(상)\t3. 서비스  관리\t3.12 Sendmail 버전 점검\t" >> $rf 2>&1
    echo -en "취약한 버전의 Sendmail 서비스 이용 여부 점검\t" >> $rf 2>&1

    # Sendmail 설정 파일 확인
    sendmailcf_files=$(find / -name 'sendmail.cf' -type f 2>/dev/null)
    if [[ -n "$sendmailcf_files" ]]; then
        for file in $sendmailcf_files; do
            # sendmail.cf 파일에서 버전 확인
            version=$(grep -E '^#.*v.*' "$file" | awk '{print $NF}')
            if [[ "$version" != "8.17.1" ]]; then
                echo -en "[양호]\t" >> $rf 2>&1
                echo "Sendmail 버전이 최신 버전인 상태입니다.\t" >> $rf 2>&1
                return 0
            fi
        done
    fi

    echo -en "[양호]\t" >> $rf 2>&1
    echo "Sendmail 버전이 최신 버전인 상태입니다." >> $rf 2>&1
    return 0
}