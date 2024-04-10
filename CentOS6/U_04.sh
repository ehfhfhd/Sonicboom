U_04() {
    echo -en "U-04(상)\t 1. 계정관리\t 1.4 패스워드 파일 보호\t" >> $rf 2>&1
    echo -en "시스템 사용자 계정(root, 일반계정) 정보가 저장된 파일(예 /etc/passwd, /etc/shadow)에 사용자 계정 패스워드가 암호화되어 저장되어 있는지 점검\t" >> $rf 2>&1
    if [ -f /etc/shadow ]; then
		vulnerable_users=$(awk -F: '/bash/ && $2 != "x" {print $1}' /etc/passwd)
		if [ -n "$vulnerable_users" ]; then
			echo -en "[취약]\t" >> $rf 2>&1
			for user in $vulnerable_users; do
					echo -n "$user " >> "$rf" 2>&1
			done
			echo -en " 사용자의 암호가 암호화로 설정되어 있지 않습니다.\t" >> $rf 2>&1
			echo "주요통신기반시설 가이드를 참고하시어 모든 사용자의 암호를 암호화로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		else
			echo -en "[양호]\t" >> $rf 2>&1
			echo "모든 사용자의 암호가 암호화로 설정되어 있는 상태입니다." >> $rf 2>&1
			return 0
		fi
	else
		echo -en "[취약]\t" >> $rf 2>&1
		echo -en "/etc/shadow 파일이 존재하지 않는 상태입니다.\t" >>$rf 2>&1
		echo "주요통신기반시설 가이드를 참고하시어 /etc/shadow 파일을 생성하시고 모든 사용자의 암호를 암호화로 설정하여 주시기 바랍니다." >> $rf 2>&1
	fi
}
U_04