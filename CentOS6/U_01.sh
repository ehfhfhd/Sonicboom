U_01() 
{
    echo -en "U-01(상)\t 1. 계정관리\t 1.1 root 계정 원격 접속 제한\t" >> $rf 2>&1
    echo -en "시스템 정책에 root 계정의 원격 터미널 접속 차단 설정이 적용 되어 있는지 점검\t" >> $rf 2>&1
    telnet_running=$(ps -ef | grep telent | grep -v grep)
    ssh_running=$(ps -ef | grep ssh | grep -v grep)

    if [ -n "$telnet_running" ]; then
        pam_securetty_config=$(cat /etc/pam.d/login | grep -i "pam_securetty.so" | grep -vE '^#|^\s#')
        securetty_config=$(cat /etc/securetty | grep '^ *pts')

        if [ -n "$pam_securetty_config" ] && [ -z "$securetty_config" ]; then
            
            echo -en "[양호]\t" >> "$rf" 2>&1
            echo "telent관련 pts/0~pts/x관련 설정이 존재하지 않으며 Uth required /lib/security/pam_security설정이 되어 있는 상태입니다."  >> $rf 2>&1
        elif [ -n "$pam_securetty_config" ] && [ -n "$securetty_config" ]; then
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo -en "/etc/securetty파일 내 pts/0~pts/x 관련 설정이 존재하는 상태입니다.\t"  >> $rf 2>&1
            echo "주요통신기반시설 가이드를 참고하시어 /etc/securetty파일 내 pts/0~pts/x 관련 설정을 제거하거나 주석 처리해주시기 바랍니다." >> $rf 2>&1
        elif [ -z "$pam_securetty_config" ] && [ -z "$securetty_config" ]; then
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo -en "/etc/pam.d/login 파일 내 Uth required /lib/security/pam_security이 주석처리 되어 있는 상태입니다.\t"  >> $rf 2>&1
            echo "주요통신기반시설 가이드를 참고하시어 /etc/pam.d/login파일 내 Uth required /lib/security/pam_security의 주석을 제거하여 주시기 바랍니다." >> $rf 2>&1
        else
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo -en "/etc/securetty파일 내 pts/0~pts/x 관련 설정이 존재하며 /etc/pam.d/login 파일 내 Uth required /lib/security/pam_security이 주석처리 되어 있는 상태입니다.\t" >> $rf 2>&1
            echo "주요통신기반시설 가이드를 참고하시어 /etc/securetty파일 내 pts/0~pts/x 관련 설정을 제거하거나 주석 처리해주시고 /etc/pam.d/login파일 내 Uth required /lib/security/pam_security의 주석을 제거하여 주시기 바랍니다." >> $rf 2>&1
        fi
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "telnet서비스가 구동중이지 않은 상태입니다." >> $rf 2>&1
    fi

    if [ -n "$ssh_running" ]; then
        permit_root_login=$(cat /etc/ssh/sshd_config | grep PermitRootLogin | grep -vE '^#|^\s#')
        if [ -n "$permit_root_login" ]; then
            echo -en "[양호]\t" >> $rf 2>&1
            echo "ssh관련 "PermitRootLogin"설정이 되어 있는 상태입니다." >> $rf 2>&1
        else
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "SSH 관련 "PermitRootLogin" 설정이 주석 처리되어 root 계정으로 직접 로그인이 가능한 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 "/etc/ssh/sshd_config" 설정 파일 내 "PermitRootLogin" 관련 주석 제거 및 값을 "no"로 설정하여 주시기 바랍니다." >> $rf 2>&1
        fi
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "ssh서비스가 구동중이지 않은 상태입니다." >> $rf 2>&1
    fi
}
U_01