U_22() {
    echo -en "U-22(상)\t3. 서비스  관리\t3.4 crond 파일 소유자 및 권한 설정\t" >> $rf 2>&1
    echo -en "Cron 관련 파일의 권한 적절성 점검\t" >> $rf 2>&1

    CRON_FILES="/etc/crontab /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d"
    ALLOWED_PERMISSION="640"
    CROND_USER="root"
    CROND_GROUP="root"
    
    # 파일 및 디렉터리 권한 확인
    for file in $CRON_FILES; do
        if [ -e "$file" ]; then
            permissions=$(stat -c "%a" "$file")
            owner=$(stat -c "%U" "$file")
            group=$(stat -c "%G" "$file")
            group_permissions=$(stat -c "%a" "$file" | cut -c2)
            if [[ ("$permissions" -le "$ALLOWED_PERMISSION") && ("$owner" == "$CROND_USER") && ("$group" == "$CROND_GROUP") && ("$group_permissions" == "4") ]]; then
                echo -en "[양호]\t" >> $rf 2>&1
                echo "$file 권한 및 소유자가 적절한 상태입니다." >> $rf 2>&1
            else
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "$file 권한 또는 소유자가 부적절한 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 일부 Cron 파일에 부여된 타사용자 권한을 제거하여 주시기 바랍니다." >> $rf 2>&1
                exit 1
            fi
        else
            echo -en "[양호]\t" >> $rf 2>&1
            echo "$file 파일 또는 디렉터리가 존재하지 않습니다." >> $rf 2>&1
        fi
    done

    # cron 관련 파일의 권한 및 소유자가 양호한 경우, crontab 명령어를 일반 사용자에게 금지
    echo -en "[양호]\t" >> $rf 2>&1
    echo "cron 관련 파일의 권한 및 소유자가 적절한 상태입니다." >> $rf 2>&1
    sed -i '/^.*cron.\{0,1\}tab.\{0,1\}$/d' /etc/group
    exit 0
}