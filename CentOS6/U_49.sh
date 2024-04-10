U_49() {
    echo -en "U-49(하)\t 1. 계정관리\t 1.10 불필요한 계정 제거\t"  >> $rf 2>&1
    echo -en "시스템 계정 중 불필요한 계정(퇴직, 전직, 휴직 등의 이유로 사용하지 않는 계정 및 장기적으로 사용하지 않는 계정 등)이 존재하는지 점검\t" >> $rf 2>&1

    unnecessary_accounts=("lp" "uucp" "nuucp")
    bash_users=$(awk -F : '$7 ~ /bash/ && $3 >= 500 {print $1}' /etc/passwd)

    for acc in "${unnecessary_accounts[@]}"; do
        if grep -q "^$acc:" /etc/passwd; then
            shell=$(awk -F : -v acc="$acc" '$1 == acc {print $7}' /etc/passwd)
            if [ "$shell" != "/sbin/nologin" ]; then
                echo -e "$acc" >> $rf 2>&1
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "시스템 계정 중 불필요한 계정이 존재하는 상태입니다.\t" >> $rf 2>&1
                if [ -n "$bash_users" ]; then
                    echo -en "[인터뷰]\t" >> $rf 2>&1
                    echo -en "로그인이 가능한 일반 사용자 계정의 목적이 확인되지 않아 담당자 확인이 필요합니다.\t" >> $rf 2>&1
                fi
                echo "주요정보통신기반시설 가이드를 참고하시어 시스템 계정 중 불필요한 계정을 삭제하여 주시기 바랍니다." >> $rf 2>&1
                return 0;
            fi
        fi
    done

    if [ -n "$bash_users" ]; then
        echo -en "[인터뷰]\t" >> $rf 2>&1
        echo "로그인이 가능한 일반 사용자 계정의 목적이 확인되지 않아 담당자 확인이 필요합니다." >> $rf 2>&1
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "시스템 계정 중 불필요한 계정이 없는 상태입니다." >> $rf 2>&1
    fi
}
U_49

#
# bash account계정 확인 -> uid값 500이상 인터뷰
# 불필요한 계정 확인 -> nologin 아니면 취약
