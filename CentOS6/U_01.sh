U_01() 
{
    echo -en "U-01(상)\t 1. 계정관리\t 1.1 root 계정 원격 접속 제한\t" >> $rf 2>&1
    echo -en "시스템 정책에 root 계정의 원격 터미널 접속 차단 설정이 적용 되어 있는지 점검\t" >> $rf 2>&1
    telnet_running=$(ps -ef | grep telent | grep -v grep)
    ssh_running=$(ps -ef | grep ssh | grep -v grep)

    telnet_service=False
    telnet_file1=False
    telent_file1=False

    ssh_service=False
    ssh_file1=False

    if [ -n "$telnet_running" ]; then
        telent_service=True
        pam_securetty_config=$(cat /etc/pam.d/login | grep -i "pam_securetty.so" | grep -vE '^#|^\s#')
        securetty_config=$(cat /etc/securetty | grep '^ *pts')
        
        if [ -z "$pam_securetty_config" ]; then
            telnet_file1=True
        fi

        if [ -n "$securetty_config" ]; then
            telnet_file2=True
        fi
    fi

    if [ -n "$ssh_running" ]; then
        ssh_service=True
        permit_root_login=$(cat /etc/ssh/sshd_config | grep PermitRootLogin | grep -vE '^#|^\s#' | grep no)
        if [ -z "$permit_root_login" ]; then
            ssh_file1=True
        fi
    fi

    # 양호 상태 출력
    print_secure_status() {
        local total_secure="${#secure[@]}"
        echo -en "[양호]\t" >> "$rf" 2>&1
        for ((i=0; i<"$total_secure"; i++)); do
            echo -n "${secure[$i]}" >> "$rf" 2>&1
            if [ "$i" -lt "$((total_secure - 1))" ]; then
                echo -n " " >> "$rf" 2>&1
            else
                echo "" >> "$rf" 2>&1
            fi
        done
    }

    # 취약 상태 및 대응 방안 출력
    print_vulnerable_status() {
        local total_vulnerabilities="${#vulnerabilities[@]}"
        echo -en "[취약]\t" >> "$rf" 2>&1
        for ((i=0; i<"$total_vulnerabilities"; i++)); do
            echo -n "${vulnerabilities[$i]}" >> "$rf" 2>&1
            if [ "$i" -lt "$((total_vulnerabilities - 1))" ]; then
                echo -en "\t" >> "$rf" 2>&1
            fi
        done

        for ((i=0; i<"$total_vulnerabilities"; i++)); do
            echo -n "${solutions[$i]}" >> "$rf" 2>&1
            if [ "$i" -lt "$((total_vulnerabilities - 1))" ]; then
                echo -n " " >> "$rf" 2>&1
            else
                echo "" >> "$rf" 2>&1
            fi
        done
    }

    secure=()
    vulnerabilities=()
    solutions=()

    if [ "$telnet_service" == "True" ]; then
        if [ "$telnet_file1" == "False" ] && [ "$telnet_file2" == "False" ]; then
            secure+=("telent관련 pts/0~pts/x관련 설정이 존재하지 않으며 \"Uth required /lib/security/pam_securetty.so\" 설정이 되어 있는 상태입니다.")
        elif [ "$telnet_file1" == "False" ] && [ "$telnet_file2" == "True" ]; then
            vulnerabilities+=("\"/etc/securetty\"파일 내 pts/0~pts/x 관련 설정이 존재하는 상태입니다.")
            solutions+=("주요통신기반시설 가이드를 참고하시어 \"/etc/securetty\" 파일 내 pts/0~pts/x 관련 설정을 제거하거나 주석 처리해주시기 바랍니다.")
        elif [ "$telnet_file1" == "True" ] && [ "$telnet_file2" == "False" ]; then
            vulnerabilities+=("\"/etc/pam.d/login\" 파일 내 \"Uth required /lib/security/pam_securetty.so\"이 설정되어 있지 않은 상태입니다.")
            solutions+=("주요통신기반시설 가이드를 참고하시어 \"/etc/pam.d/login\" 파일 내 \"Uth required /lib/security/pam_securetty.so\" 를 설정하여 주시기 바랍니다.")
        else
            vulnerabilities+=("\"/etc/securetty\"파일 내 pts/0~pts/x 관련 설정이 존재하며 /etc/pam.d/login 파일 내 \"Uth required /lib/security/pam_securetty.so\" 이 설정되어 있지 않은 상태입니다.")
            solutions+=("주요통신기반시설 가이드를 참고하시어 \"/etc/securetty\"파일 내 pts/0~pts/x 관련 설정을 제거하거나 주석 처리해주시고 \"/etc/pam.d/login\" 파일 내 \"Uth required /lib/security/pam_security\" 를 설정하여 주시기 바랍니다.")
        fi
    else
        secure+=("telnet 서비스가 구동중이지 않은 상태입니다.")
    fi

    if [ "$ssh_service" == "True" ]; then
        if [ "$ssh_file1" == "False" ]; then
            secure+=("ssh관련 \"PermitRootLogin\" 설정이 되어 있는 상태입니다.")
        else
            vulnerabilities+=("SSH 관련 \"PermitRootLogin\" 설정이 주석 처리되어 root 계정으로 직접 로그인이 가능한 상태입니다.")
            solutions+=("주요정보통신기반시설 가이드를 참고하시어 \"/etc/ssh/sshd_config\" 설정 파일 내 \"PermitRootLogin\" 관련 주석 제거 및 값을 \"no\"로 설정하여 주시기 바랍니다.")
        fi
    else
        secure+=("ssh 서비스가 구동중이지 않은 상태입니다.")
    fi

    if [ "${#vulnerabilities[@]}" -gt 0 ]; then
        print_vulnerable_status
    else
        print_secure_status
    fi
}
U_01