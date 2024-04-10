U_45() {
    echo -en "U-45(하)\t 1. 계정관리\t 1.6 root 계정 su 제한\t"  >> "$rf" 2>&1
    echo -en "시스템 사용자 계정 그룹 설정 파일(예 /etc/group)에 su 관련 그룹이 존재하는지 점검 및 su 명령어가 su 관련 그룹에서만 허용되도록 설정되어 있는지 점검\t" >> $rf 2>&1

    pam_wheelso_count=$(grep -vE '^#|^\s#' /etc/pam.d/su | grep 'pam_wheel.so')
    su_file_permission=$(stat -c %a /bin/su)

    if [ -z "$pam_wheelso_count" ] && [ "$su_file_permission" -ge 4750 ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "/etc/pam.d/su 파일에 pam_wheel.so 모듈이 설정되어 있지 않으며 /bin/su파일의 권한이 $su_file_permission 인 상태입니다.\t" >> $rf 2>&1
        echo "주요통신기반시설 가이드를 참고하시어 /etc/pam.d/su파일에 pam_wheel.so 모듈을 설정하여 주시고 /bin/su파일의 권한을 4750이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
    elif [ -z "$pam_wheelso_count" ] && [ "$su_file_permission" -le 4750 ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "/etc/pam.d/su 파일에 pam_wheel.so 모듈이 설정되어 있지 않는 상태입니다.\t" >> $rf 2>&1
        echo "주요통신기반시설 가이드를 참고하시어 /etc/pam.d/su파일에 pam_wheel.so 모듈을 설정하여 주시기 바랍니다." >> $rf 2>&1
    elif [ -n "$pam_wheelso_count" ] && [ "$su_file_permission" -ge 4750 ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "/bin/su파일의 권한이 $su_file_permmission 인 상태입니다.\t" >> $rf 2>&1
        echo "주요통신기반시설 가이드를 참고하시어 /bin/su파일의 권한을 4750이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "/etc/pam.d/su 파일에 pam_wheel.so 모듈이 설정되어 있으며 /bin/su파일의 권한이 $su_file_permmission 인 상태입니다." >> $rf 2>&1
    fi
    
}
U_45

#권한 자세하게 확인....?