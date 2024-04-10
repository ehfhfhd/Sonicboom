U_02() {
	echo -en "U-02(상)\t 1. 계정관리\t 1.2 패스워드 복잡성 설정\t"  >> $rf 2>&1
	echo -en "시스템 정책에 사용자 계정(root 및 일반 계정 모두 해당) 패스워드 복잡성 관련 설정이 되어 있는지 점검\t"  >> $rf 2>&1

    pam_cracklib_path=$(find / -name 'pam_cracklib.so' -type f -print)

    if [ -n "$pam_cracklib_path" ]; then
        pam_password=$(grep "password" /etc/pam.d/system-auth | grep "pam_cracklib.so")
        if [ -n "$pam_password" ]; then
            minlen_value=$(echo "$pam_password" | awk -F'minlen=' '{print $2}' | awk '{print $1}')
            o_lcredit_value=$(echo "$pam_password" | awk -F'lcredit=' '{print $2}' | awk '{print $1}')
            o_ucredit_value=$(echo "$pam_password" | awk -F'ucredit=' '{print $2}' | awk '{print $1}')
            o_dcredit_value=$(echo "$pam_password" | awk -F'dcredit=' '{print $2}' | awk '{print $1}')
            o_ocredit_value=$(echo "$pam_password" | awk -F'ocredit=' '{print $2}' | awk '{print $1}')

            has_lower=$(awk -v lc="$o_lcredit_value" 'BEGIN { print (lc == "" || lc >= 0) ? "false" : "true" }') #영문(소)
            has_upper=$(awk -v uc="$o_ucredit_value" 'BEGIN { print (uc == "" || uc >= 0) ? "false" : "true" }') #영문(대)
            has_digit=$(awk -v dc="$o_dcredit_value" 'BEGIN { print (dc == "" || dc >= 0) ? "false" : "true" }') #숫자
            has_special=$(awk -v oc="$o_ocredit_value" 'BEGIN { print (oc == "" || oc >= 0) ? "false" : "true" }') #특수문자

            lcredit_value=$(echo "$pam_password" | awk -F'lcredit=' '{print $2}' | awk '{gsub("-", ""); print $1}')
            if [ -z "$lcredit_value" ]; then
              o_lcredit_value="-"
            fi
            ucredit_value=$(echo "$pam_password" | awk -F'ucredit=' '{print $2}' | awk '{gsub("-", ""); print $1}')
            if [ -z "$ucredit_value" ]; then
              o_ucredit_value="-"
            fi
            dcredit_value=$(echo "$pam_password" | awk -F'dcredit=' '{print $2}' | awk '{gsub("-", ""); print $1}')
            if [ -z "$dcredit_value" ]; then
              o_dcredit_value="-"
            fi
            ocredit_value=$(echo "$pam_password" | awk -F'ocredit=' '{print $2}' | awk '{gsub("-", ""); print $1}')
            if [ -z "$ocredit_value" ]; then
              o_credit_value="-"
            fi

            if [ -z "$minlen_value" ]; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수 값이 설정되어 있지 않으며 알파벳 대/소문자 , 숫자, 특수문자) 이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 "/etc/pam.d/system-auth" 설정 파일 내 패스워드 복잡성 설정 값(영문·숫자·특수문자를 조합하여 2종류 조합 시 10자리 이상, 3종류 이상 조합 시 8자리 이상의 패스워드)을 회사 내부 규정 및 지침에 맞게 설정하여 주시기 바랍니다." >> $rf 2>&1
            else
                if [[ $minlen_value -ge 10 ]]; then #10 이상
                    if [[ $has_lower == "true" && $has_upper == "true" && $has_digit == "true" && $has_special == "true" ]]; then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 소문자 최소 $lcredit_value 개, 알파벳 대문자 최소 $ucredit_value 개, 숫자 최소 $dcredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "false" && $has_upper == "true" && $has_digit == "true" && $has_special == "true" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 대문자 최소 $ucredit_value 개, 숫자 최소 $dcredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "true" && $has_upper == "false" && $has_digit == "true" && $has_special == "true" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 소문자 최소 $lcredit_value 개, 숫자 최소 $dcredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "false" && $has_upper == "false" && $has_digit == "true" && $has_special == "true" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 숫자 최소 $dcredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "true" && $has_upper == "true" && $has_digit == "false" && $has_special == "true" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 소문자 최소 $lcredit_value 개, 알파벳 대문자 최소 $ucredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "true" && $has_upper == "true" && $has_digit == "true" && $has_special == "false" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 소문자 최소 $lcredit_value 개, 알파벳 대문자 최소 $ucredit_value 개, 숫자 최소 $dcredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "true" && $has_upper == "false" && $has_digit == "true" && $has_special == "false" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 소문자 최소 $lcredit_value 개, 숫자 최소 $dcredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "true" && $has_upper == "false" && $has_digit == "false" && $has_special == "true" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 소문자 최소 $lcredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "false" && $has_upper == "true" && $has_digit == "true" && $has_special == "false" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 대문자 최소 $ucredit_value 개, 숫자 최소 $dcredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "false" && $has_upper == "true" && $has_digit == "false" && $has_special == "true" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 대문자 최소 $ucredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    else
                        echo -en "[취약]\t" >> $rf 2>&1
                        echo -en "/etc/pam.d/system-auth 설정 파일 내 패스워드 복잡성 설정 값으로 최소자리수가 $minlen_value 이며 lcredit: $o_lcredit_value, ucredit: $o_ucredit_value, dcredit: $o_dcredit_value, ocredit: $o_ocredit_value 으로 설정되어 있는 상태입니다.\t" >> $rf 2>&1
                        echo "주요통신기반시설 가이드를 참고하시어 영문, 숫자, 특수문자를 조합하여 2종류 이상 조합되도록 "/etc/pam.d/system-auth" 설정 파일 내 lcredit, ucredit, dcredit, oredit 값을 －1 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
                    fi
                elif [[ $minlen_value -ge 8 ]]; then # 10 미만, 8이상
                    if [[ $has_lower == "true" && $has_upper == "true" && $has_digit == "true" && $has_special == "true" ]]; then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 소문자 최소 $lcredit_value 개, 알파벳 대문자 최소 $ucredit_value 개, 숫자 최소 $dcredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "false" && $has_upper == "true" && $has_digit == "true" && $has_special == "true" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 대문자 최소 $ucredit_value 개, 숫자 최소 $dcredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    elif [[ $has_lower == "true" && $has_upper == "false" && $has_digit == "true" && $has_special == "true" ]];then
                        echo -en "[양호]\t" >> $rf 2>&1
                        echo "/etc/pam.d/system-auth 설정 파일 내 패스워드 최소자리수가 $minlen_value 이며 알파벳 소문자 최소 $lcredit_value 개, 숫자 최소 $dcredit_value 개, 특수문자 최소 $ocredit_value 개로 설정되어 있는 상태입니다." >> $rf 2>&1
                    else
                        echo -en "[취약]\t" >> $rf 2>&1
                        echo -en "/etc/pam.d/system-auth 설정 파일 내 패스워드 복잡성 설정 값으로 최소자리수가 $minlen_value 이며 lcredit: $o_lcredit_value, ucredit: $o_ucredit_value, dcredit: $o_dcredit_value, ocredit: $o_ocredit_value 으로 설정되어 있는 상태입니다.\t" >> $rf 2>&1
                        echo "주요통신기반시설 가이드를 참고하시어 영문, 숫자, 특수문자를 조합하여 3종류 이상 조합되도록 "/etc/pam.d/system-auth" 설정 파일 내 lcredit, ucredit, dcredit, oredit 값을 －1 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
                    fi
                else
                    echo -en "[취약]\t" >> $rf 2>&1
                    echo -en "/etc/pam.d/system-auth 설정 파일 내 패스워드 복잡성 설정 값으로 최소자리수가 $minlen_value 로 설정되어 있는 상태입니다.\t" >> $rf 2>&1
                    echo "주요통신기반시설 가이드를 참고하시어 "/etc/pam.d/system-auth" 설정 파일 내 최소자리수를 8이상으로 설정하여 주시기 바랍니다." >> $rf 2>&1
                fi
            fi
        else
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "/etc/pam.d/system-auth 설정 파일 내 패스워드 복잡성 설정 값 (최소자리수, 알파벳 대/소문자 , 숫자, 특수문자) 이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 "/etc/pam.d/system-auth" 설정 파일 내 패스워드 복잡성 설정 값(영문·숫자·특수문자를 조합하여 2종류 조합 시 10자리 이상, 3종류 이상 조합 시 8자리 이상의 패스워드)을 회사 내부 규정 및 지침에 맞게 설정하여 주시기 바랍니다." >> $rf 2>&1
        fi
    else
        echo -en "[취약]\t" >> $rf 2>&1
        echo "시스템 내 pam_cracklib.so 모듈이 존재하지 않는 상태입니다." >> $rf 2>&1
    fi   
}
U_02