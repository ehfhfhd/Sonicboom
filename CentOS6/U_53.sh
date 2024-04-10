U_53() {
    echo -en "U-53(하)\t 1. 계정관리\t 1.14 사용자 shell 점검\t"  >> $rf 2>&1
    echo -en "로그인이 불필요한 계정(adm, sys, daemon 등)에 쉘 부여 여부 점검\t" >> $rf 2>&1

    bash_vulnerability=False
    unknown_vulnerability=False

    if [ -n /etc/passwd ]; then
        vulnerable_users=$(grep -E "^(daemon|bin:|sys|adm|listen|nobody|nobody4|noaccess|diag|operator|gopher|games|lp|uucp|nuucp):" /etc/passwd | awk -F : '$7!="/bin/false" && $7!="/sbin/nologin" {print $1}')
        if [ -n "$vuln_users" ]; then
            unknown_vulnerability=True
        fi
    fi
    
    bash_users=$(cat /etc/passwd | grep bash | awk -F : '{print $1}')
    Vulnerable_users=""
    for user in "${bash_users[@]}"; do
        user_home=$(grep "^$user:" /etc/passwd | awk -F : '{print $6}')
        if [ -f "$user_home/.bash_history" ]; then
            continue
        else
            Vulnerable_users+="$user "
        fi
    done

    if [ -n "$Vulnerable_users" ]; then
        bash_vulnerability=True
    fi
    
    if [ "$bash_vulnerability" == "False" ] && [ "$unknown_vulnerability" == "False" ]; then
        echo -en "[양호]\t" >> $rf 2>&1
        echo -n "로그인이 불필요한 계정에 /bin/false, sbin/nologin 쉘이 부여되어 있는 상태입니다." >> $rf 2>&1
        echo "로그인이 가능한 모든 계정의 bash_history 파일이 존재하는 상태입니다." >> $rf 2>&1
    elif [ "$bash_vulnerability" == "True" ] && [ "$unknown_vulnerability" == "False" ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "로그인이 가능한 사용자($Vulnerable_users)의 bash_history 파일이 존재하지 않는 상태입니다.\t">> $rf 2>&1
        echo "주요통신기반시설 가이드를 참고하시어 사용되지 않는 로그인 가능한 사용자 계정을 제거하거나 /bin/false 또는 /sbin/nologin 쉘을 부여하여 주시기 바랍니다.">> $rf 2>&1
        
    elif [ "$bash_vulnerability" == "False" ] && [ "$unknown_vulnerability" == "True" ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "로그인이 불필요한 계정($vuln_users)에 /bin/false, /sbin/nologin 쉘이 부여되지 않은 상태입니다.\t" >> $rf 2>&1
        echo "주요통신기반시설 가이드를 참고하시어 로그인이 불필요한 계정에 /bin/false 또는 /sbin/nologin 쉘을 부여하여 주시기 바랍니다." >> $rf 2>&1
    else
        echo "$bash_vulnerability, $unknown_vulnerability" >> $rf
        echo -en "[취약]\t" >> $rf 2>&1
        echo -n "로그인이 불필요한 계정($vuln_users)에 /bin/false, /sbin/nologin 쉘이 부여되지 않은 상태입니다." >> $rf 2>&1
        echo -en "로그인이 가능한 일반사용자($Vulnerable_users)의 bash_history 파일이 존재하지 않는 상태입니다.\t">> $rf 2>&1
        echo -n "주요통신기반시설 가이드를 참고하시어 로그인이 불필요한 계정에 /bin/false 또는 /sbin/nologin 쉘을 부여하여 주시기 바랍니다." >> $rf 2>&1
        echo "주요통신기반시설 가이드를 참고하시어 사용되지 않는 로그인 가능한 사용자 계정을 제거하거나 /bin/false 또는 /sbin/nologin 쉘을 부여하여 주시기 바랍니다.">> $rf 2>&1
    fi
}
U_53