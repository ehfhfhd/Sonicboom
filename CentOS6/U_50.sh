U_50() {
    echo -en "U-50(하)\t  1. 계정관리\t 1.11 관리자 그룹에 최소한의 계정 포함\t"  >> $rf 2>&1
    echo -en "시스템 관리자 그룹에 최소한(root 계정과 시스템 관리에 허용된 계정)의 계정만 존재하는지 점검\t" >> $rf 2>&1

    root_group_members=$(grep '^root:' /etc/group | awk -F : '{print $4}')

    if [ -n "$root_group_members" ]; then
        non_root_users=""

        for user in $root_group_members; do
            if [ "$user" != "root" ]; then
                non_root_users+="$user "
            fi
        done
        if [ -n "$non_root_users" ]; then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "관리자 그룹(root)에 불필요한 계정($non_root_users)이 등록되어 있습니다.\t" >> $rf 2>&1
            echo "주요통신기반시설 가이드를 참고하시어 관리자 그룹(root)내의 불필요한 계정을 삭제하여 주시기 바랍니다." >> $rf 2>&1
        else
            echo -en "[양호]\t" >> $rf 2>&1
            echo "관리자 그룹(root)에 타사용자가 추가되어 있지 않은 상태입니다." >> $rf 2>&1
        fi
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "관리자 그룹(root)에 타사용자가 추가되어 있지 않은 상태입니다." >> $rf 2>&1
    fi
}
U_50