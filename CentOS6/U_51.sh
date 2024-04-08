U_51() {
    echo -en "U-51(하)\t 1. 계정관리\t 1.12 계정이 존재하지 않는 GID 금지\t"  >> $rf 2>&1
    echo -en "그룹(예 /etc/group) 설정 파일에 불필요한 그룹(계정이 존재하지 않고 시스템 관리나 운용에 사용되지 않는 그룹, 계정이 존재하고 시스템 관리나 운용에 사용되지 않는 그룹 등)이 존재하는지 점검\t" >> $rf 2>&1

    unnecessary_groups=($(grep -vE '^#|^\s#' /etc/group | awk -F : '$3>=500 && $4==null {print $3}' | uniq))

    index=0
    
    while [ $index -lt ${#unnecessary_groups[@]} ]; do
        group_id="${unnecessary_groups[$index]}"
        if ! awk -F : '{print $4}' /etc/passwd | grep -q "^$group_id$"; then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "계정이 존재하지 않는 불필요한 그룹이 존재하는 상태입니다.\t" >> $rf 2>&1
            echo "주요통신기반시설 가이드를 참고하시어 불필요한 그룹을 삭제하여 주시기 바랍니다." >> $rf 2>&1
            return 0
        fi
        ((index++))
    done
    
    echo -en "[양호]\t" >> $rf 2>&1
    echo "/etc/group 설정 파일에 불필요한 그룹이 존재하지 않는 상태입니다." >> $rf 2>&1
}

U_51
#완료