U_52() {
    echo -en "U-52(중)\t 1. 계정관리\t 1.13 동일한 UID 금지\t"  >> $rf 2>&1
    echo -en "/etc/passwd 파일 내 UID가 동일한 사용자 계정 존재 여부 점검\t" >> $rf 2>&1
    duplicated_uids=$(awk -F: '{print $3}' /etc/passwd | sort | uniq -d)

    if [[ -n $duplicated_users ]]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "동일한 UID로 설정된 사용자 계정이 존재하는 상태입니다.\t" >> $rf 2>&1
        echo "주요통신기반시설 가이드를 참고하시어 동일한 UID로 설정된 사용자 계정의 UID를 변경하여 주시기 바랍니다." >> $rf 2>&1
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "동일한 UID로 설정된 사용자 계정이 존재하지 않는 상태입니다." >> $rf 2>&1
    fi
}
U_52
