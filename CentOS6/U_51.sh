rf="result.txt"
U_51() {
    echo -en "U-51(하)\t 1. 계정관리\t 1.12 계정이 존재하지 않는 GID 금지\t"  >> $rf 2>&1
    echo -en "그룹(예 /etc/group) 설정 파일에 불필요한 그룹(계정이 존재하지 않고 시스템 관리나 운용에 사용되지 않는 그룹, 계정이 존재하고 시스템 관리나 운용에 사용되지 않는 그룹 등)이 존재하는지 점검\t" >> $rf 2>&1

    bash_users=$(cat /etc/passwd | grep bash | awk -F : '{print $1}')
    vuln_users=""
    no_group_users=""

    for user in $bash_users; do
        group=$(grep "^$user:" /etc/group | awk -F : '{print $1}')
        if [ -n "$group" ]; then
            group_user=$(grep "^$user:" /etc/group | awk -F : '{print $4}')
            if [ -n "$group_user" ]; then
                vuln_users+="$user "
            fi
        else
            no_group_users+="$user "
        fi
    done

    if [ -n "$vuln_users" ]; then
        if [ -n "$no_group_users" ];then
            echo -en "[취약]\t" >> $rf 2>&1
            echo "로그인이 가능한 사용자 계정($vuln_users)의 그룹 내 타사용자가 존재하며 $no_group_users 사용자의 그룹이 존재하지 않는 상태입니다." >> $rf 2>&1
        else
            echo -en "[취약]\t" >> $rf 2>&1
            echo "로그인이 가능한 사용자 계정($vuln_users)의 그룹 내 타사용자가 존재하는 상태입니다." >> $rf 2>&1
        fi
    else  
        if [ -n "$no_group_users" ];then
            echo -en "[취약]\t" >> $rf 2>&1
            echo "로그인이 가능한 $no_group_users 사용자의 그룹이 존재하지 않는 상태입니다." >> $rf 2>&1
        else 
            echo -en "[양호]\t" >> $rf 2>&1
            echo "로그인이 가능한 모든 사용자 계정의 그룹 내 타사용자가 존재하지 않고 모든 그룹이 존재하는 상태입니다." >> $rf 2>&1
        fi
    fi
}
U_51