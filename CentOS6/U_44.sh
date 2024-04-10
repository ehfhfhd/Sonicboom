U_44() {
    echo -en "U-44(중)\t 1. 계정관리\t 1.5 root 이외의 UID가 '0' 금지\t" >> "$rf" 2>&1
    echo -en "사용자 계정 정보가 저장된 파일(예 /etc/passwd)에 root(UID=0) 계정과 동일한 UID(User Identification)를 가진 계정이 존재하는지 점검\t" >> "$rf" 2>&1
    if [ -f /etc/passwd ]; then
        user_with_uid_zero=$(awk -F : '$3==0 && $1!="root" {print $1}' /etc/passwd)
        if [ -z "$user_with_uid_zero" ]; then
            echo -en "[양호]\t" >> "$rf" 2>&1
            echo "root 계정을 제외한 로그인이 가능한 모든 사용자 UID값이 '0'으로 설정되어 있지 않은 상태입니다."  >> "$rf" 2>&1
        else
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo -en "root 계정과 동일한 UID(0)를 갖는 사용자("  >> "$rf" 2>&1
            for user in $user_with_uid_zero; do
                echo -n "$user " >> "$rf" 2>&1
            done
            echo -en ")가 존재하는 상태입니다.\t"  >> "$rf" 2>&1
            echo -n "주요통신기반시설 가이드를 참고하시어 " >> "$rf" 2>&1
            for user in $user_with_uid_zero; do
                echo -n "$user " >> "$rf" 2>&1
            done
            echo " 계정의 UID값을 변경하여 주시기 바랍니다." >> "$rf" 2>&1
        fi
    fi
}
U_44
