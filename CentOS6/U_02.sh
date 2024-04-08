U_02() {
	echo -en "U-02(상)\t 1. 계정관리\t 1.2 패스워드 복잡성 설정\t"  >> $rf 2>&1
	echo -en "시스템 정책에 사용자 계정(root 및 일반 계정 모두 해당) 패스워드 복잡성 관련 설정이 되어 있는지 점검\t"  >> $rf 2>&1

    pam_password=$(grep "password" /etc/pam.d/system-auth | grep "pam_cracklib.so")

    if [ -n "$pam_password" ]; then
        minlen_value=$(echo "$pam_password" | awk -F'minlen=' '{print $2}' | awk '{print $1}')
        lcredit_value=$(echo "$pam_password" | awk -F'lcredit=' '{print $2}' | awk '{print $1}')
        ucredit_value=$(echo "$pam_password" | awk -F'ucredit=' '{print $2}' | awk '{print $1}')
        dcredit_value=$(echo "$pam_password" | awk -F'dcredit=' '{print $2}' | awk '{print $1}')
        ocredit_value=$(echo "$pam_password" | awk -F'ocredit=' '{print $2}' | awk '{print $1}')

        if [ -z "$minlen_value" ] && [ -z "$lcredit_value" ] && [ -z "$ucredit_value" ] && [ -z "$dcredit_value" ] && [ -z "$ocredit_value" ]; then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "/etc/pam.d/system-auth 설정 파일 내 패스워드 복잡성 설정 값 (최소자리수, 알파벳 대/소문자 , 숫자, 특수문자) 이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어  "/etc/pam.d/system-auth" 설정 파일 내 패스워드 복잡성 설정 값을 회사 내부 규정 및 지침에 맞게 설정하여 주시기 바랍니다." >> $rf 2>&1
        else
            echo -en "[양호]\t" >> $rf 2>&1
            echo "/etc/pam.d/system-auth 설정 파일 내 최소자리수: $minlen_value, 소문자: $Icredit_value, 대문자: $ucredit_value, 숫자: $dcredit_value, 특수문자: $ocredit_value 로 설정되어 있는 상태입니다." >> $rf 2>&1
        fi
    else
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "/etc/pam.d/system-auth 설정 파일 내 패스워드 복잡성 설정 값 (최소자리수, 알파벳 대/소문자 , 숫자, 특수문자) 이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어  "/etc/pam.d/system-auth" 설정 파일 내 패스워드 복잡성 설정 값을 회사 내부 규정 및 지침에 맞게 설정하여 주시기 바랍니다." >> $rf 2>&1
    fi    
}
U_02