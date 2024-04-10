U_20() {
    echo -en "U-20(상)\t3. 서비스  관리\t3.2 Anonymous FTP 비활성화\t" >> $rf 2>&1
    echo -en "익명 FTP 접속 허용 여부 점검\t" >> $rf 2>&1

    # FTP 계정 존재 여부 확인
    if [ $(grep -q "^ftp:" /etc/passwd) ]; then
        # proFTP를 사용하는 경우
        if [ -f "/etc/proftpd/proftpd.conf" ]; then
            if grep -qE "^User|^UserAlias" /etc/proftpd/proftpd.conf; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "proFTP 설정 파일에서 'User'또는 'UserAlias' 옵션이 활성화 되어 있는 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 proftpd.conf 파일에서 User 및 Useralias 항목을 주석처리 해주시기 바랍니다." >> $rf 2>&1
            else
                echo -en "[양호]\t" >> $rf 2>&1
                echo "proFTP 설정 파일에서 anonymous 접속이 비활성화 되어 있는 상태입니다." >> $rf 2>&1
            fi
        fi
        # vsFTP를 사용하는 경우
        if [ -f "/etc/vsftpd/vsftpd.conf" ]; then
            if grep -q "^anonymous_enable=NO" /etc/vsftpd/vsftpd.conf; then
                echo -en "[양호]\t" >> $rf 2>&1
                echo "vsFTP 설정 파일에서 anonymous 접속이 비활성화 되어 있는 상태입니다." >> $rf 2>&1
            else
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "vsFTP 설정 파일에서 'anonymous_enable'이 활성화 되어 있는 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 vsftpd.conf 파일에서 anonymous_enable을 NO로 설정하여 주시기 바랍니다." >> $rf 2>&1
            fi
        fi
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "FTP 데몬이 비활성화되어 있는 상태입니다." >> $rf 2>&1
    fi
}