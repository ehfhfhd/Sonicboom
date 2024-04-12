rf="Tests_$(date '+%F_%H:%M:%S').txt"

U_05() {
	echo -en "U-05(상)\t2. 파일 및 디렉토리 관리\t2.1 root홈, 패스 디렉터리 권한 및 패스 설정\t"  >> $rf 2>&1
	echo -en "PATH 환경변수에 “.” 이 맨 앞이나 중간에 포함되지 않은 경우\t"  >> $rf 2>&1
	if [ `echo $PATH | grep -E '\.:|::' | wc -l` -gt 0 ]; then
		echo -en "[취약]\t" >> $rf 2>&1
		echo -en "PATH 환경 변수 내에 "." 또는 "::"이 포함되어 있는 상태입니다.\t" >> $rf 2>&1
		echo "주요정보통신기반시설 가이드를 참고하시어 PATH 환경 변수 내에 "." 또는 "::"를 제거하여 주시기 바랍니다." >> $rf 2>&1
		return 0
	else
		echo -en "[양호]\t" >> $rf 2>&1
		echo "PATH 환경변수 맨 앞 및 중간에 "." 또는 "::"이 포함되어 있지 않은 상태입니다." >> $rf 2>&1
		return 0
	fi
}

U_06() {
	echo -en "U-06(상)\t2. 파일 및 디렉토리 관리\t2.2 파일 및 디렉터리 소유자 설정\t"  >> $rf 2>&1
	echo -en "소유자가 존재하지 않는 파일 및 디렉터리가 존재하지 않는 경우\t"  >> $rf 2>&1
	if [ `find / \( -nouser -or -nogroup \) 2>/dev/null | wc -l` -gt 0 ]; then
		echo -en "[인터뷰]\t" >> $rf 2>&1
		echo "소유자가 확인되지 않은 다수의 파일이 존재하고 있어 담당자 확인이 필요합니다." >> $rf 2>&1
		return 0
	else
		echo -en "[양호]\t" >> $rf 2>&1
		echo "소유자가 존재하지 않는 파일 및 디렉터리가 존재하지 않은 상태입니다.\t" >> $rf 2>&1
		return 0
	fi
}

U_07() {
	echo -en "U-07(상)\t2. 파일 및 디렉토리 관리\t2.3 /etc/passwd 파일 소유자 및 권한 설정\t"  >> $rf 2>&1
	echo -en " /etc/passwd 파일의 소유자가 root이고, 권한이 644 이하인 경우\t"  >> $rf 2>&1
	if [ -f /etc/passwd ]; then		
		etc_passwd_owner_name=`ls -l /etc/passwd | awk '{print $3}'`
		if [[ $etc_passwd_owner_name =~ root ]]; then
			etc_passwd_permission=`stat -c %03a /etc/passwd`
			etc_passwd_owner_permission=`stat -c %03a /etc/passwd | cut -c1`
			etc_passwd_group_permission=`stat -c %03a /etc/passwd | cut -c2`
			etc_passwd_other_permission=`stat -c %03a /etc/passwd | cut -c3`
			if [ $etc_passwd_owner_permission -eq 0 ] || [ $etc_passwd_owner_permission -eq 2 ] || [ $etc_passwd_owner_permission -eq 4 ] || [ $etc_passwd_owner_permission -eq 6 ]; then
				if [ $etc_passwd_group_permission -eq 0 ] || [ $etc_passwd_group_permission -eq 4 ]; then
					if [ $etc_passwd_other_permission -eq 0 ] || [ $etc_passwd_other_permission -eq 4 ]; then
						echo -en "[양호]\t" >> $rf 2>&1
						echo " /etc/passwd 파일의 소유자가 root이고, 권한이 644 이하인 상태입니다." >> $rf 2>&1
						return 0
					fi
				fi
			fi
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/passwd 파일에 대한 권한이 ${etc_passwd_permission} 으로 취약한 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/passwd 파일 권한을 644(-rw-r--r--) 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		else
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en "/etc/passwd 파일 소유자(owner)를 root가 아닌 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/passwd 파일의 소유자(owner)를 root로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		fi
	else
		echo -en "[N/A]\t" >> $rf 2>&1
		echo " /etc/passwd 파일이 없는 상태입니다." >> $rf 2>&1
		return 0
	fi
}

U_08() {
	echo -en "U-08(상)\t2. 파일 및 디렉토리 관리\t2.4 /etc/shadow 파일 소유자 및 권한 설정\t"  >> $rf 2>&1
	echo -en " /etc/shadow 파일의 소유자가 root이고, 권한이 400 이하인 경우\t"  >> $rf 2>&1
	if [ -f /etc/shadow ]; then
		etc_shadow_owner_name=`ls -l /etc/shadow | awk '{print $3}'`
		if [[ $etc_shadow_owner_name =~ root ]]; then
		etc_shadow_permission=`stat -c %03a /etc/shadow`
		etc_shadow_owner_permission=`stat -c %03a /etc/shadow | cut -c1`
		etc_shadow_group_permission=`stat -c %03a /etc/shadow | cut -c2`
		etc_shadow_other_permission=`stat -c %03a /etc/shadow | cut -c3`
			if [ $etc_shadow_owner_permission -eq 0 ] || [ $etc_shadow_owner_permission -eq 4 ]; then
				if [ $etc_shadow_group_permission -eq 0 ]; then
					if [ $etc_shadow_other_permission -eq 0 ]; then
						echo -en "[양호]\t" >> $rf 2>&1
						echo " /etc/shadow 파일의 소유자가 root이고, 권한이 400 이하인 상태입니다." >> $rf 2>&1
						return 0
					fi
				fi
			fi
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/shadow 파일에 대한 권한이 ${etc_shadow_permission} 으로 취약한 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/shadow 파일 권한을 400(-r--------) 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		else
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/shadow 파일의 소유자(owner)가 root가 아닌 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/shadow 파일의 소유자(owner)를 root로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		fi
	else
		echo -en "[N/A]\t" >> $resultfile 2>&1
		echo " /etc/shadow 파일이 없는 상태입니다." >> $resultfile 2>&1
		return 0
	fi
}

U_09() {
	echo -en "U-09(상)\t2. 파일 및 디렉토리 관리\t2.5 /etc/hosts 파일 소유자 및 권한 설정\t"  >> $rf 2>&1
	echo -en " /etc/hosts 파일의 소유자가 root이고, 권한이 600인 이하인 경우\t"  >> $rf 2>&1
	if [ -f /etc/hosts ]; then
		etc_hosts_owner_name=`ls -l /etc/hosts | awk '{print $3}'`
		if [[ $etc_hosts_owner_name =~ root ]]; then
			etc_hosts_permission=`stat -c %03a /etc/hosts`
			etc_hosts_owner_permission=`stat -c %03a /etc/hosts | cut -c1`
			etc_hosts_group_permission=`stat -c %03a /etc/hosts | cut -c2`
			etc_hosts_other_permission=`stat -c %03a /etc/hosts | cut -c3`
			if [ $etc_hosts_owner_permission -eq 0 ] || [ $etc_hosts_owner_permission -eq 2 ] || [ $etc_hosts_owner_permission -eq 4 ] || [ $etc_hosts_owner_permission -eq 6 ]; then
				if [ $etc_hosts_group_permission -eq 0 ]; then
					if [ $etc_hosts_other_permission -eq 0 ]; then
						echo -en "[양호]\t" >> $rf 2>&1
						echo " /etc/hosts 파일의 소유자가 root이고, 권한이 600인 이하인 상태입니다." >> $rf 2>&1
						return 0
					fi
				fi
			fi
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/hosts 파일에 대한 권한이 ${etc_hosts_permission} 으로 취약한 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/hosts 파일 권한을 600(-rw-------) 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		else
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/hosts 파일의 소유자(owner)가 root가 아닌 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/hosts 파일의 소유자(owner)를 root로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		fi
	else
		echo -en "[N/A]\t" >> $rf 2>&1
		echo " /etc/hosts 파일이 없는 상태입니다." >> $rf 2>&1
		return 0
	fi
}

U_10() {
	echo -en "U-10(상)\t2. 파일 및 디렉토리 관리\t2.6 /etc/(x)inetd.conf 파일 소유자 및 권한 설정\t"  >> $rf 2>&1
	echo -en " /etc/(x)inetd.conf 파일의 소유자가 root이고, 권한이 600인 경우\t"  >> $rf 2>&1
	if [ -f /etc/inetd.conf ]; then
		etc_inetd_owner_name=`ls -l /etc/inetd.conf | awk '{print $3}'`
		if [[ $etc_inetd_owner_name =~ root ]]; then
			etc_inetd_permission=`stat -c %03a /etc/inetd.conf`
			etc_inetd_owner_permission=`stat -c %03a /etc/inetd.conf | cut -c1`
			etc_inetd_group_permission=`stat -c %03a /etc/inetd.conf | cut -c2`
			etc_inetd_other_permission=`stat -c %03a /etc/inetd.conf | cut -c3`
			if [ $etc_inetd_owner_permission -eq 0 ] || [ $etc_inetd_owner_permission -eq 2 ] || [ $etc_inetd_owner_permission -eq 4 ] || [ $etc_inetd_owner_permission -eq 6 ]; then
				if [ $etc_inetd_group_permission -eq 0 ]; then
					if [ $etc_inetd_other_permission -eq 0 ]; then
						echo -en "[양호]\t" >> $rf 2>&1
						echo " /etc/inetd.conf 파일의 소유자가 root이고, 권한이 600인 이하인 상태입니다." >> $rf 2>&1
						return 0
					fi
				fi
			fi
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/inetd.conf 파일에 대한 권한이 ${etc_inetd_permission} 으로 취약한 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/inetd.conf 파일 권한을 600(-rw-------) 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		else
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/inetd.conf 파일의 소유자(owner)가 root가 아닌 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/inetd.conf 파일의 소유자(owner)를 root로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		fi
	else
		if [ -f /etc/xinetd.conf ]; then
			etc_xinetd_owner_name=`ls -l /etc/xinetd.conf | awk '{print $3}'`
			if [[ $etc_xinetd_owner_name =~ root ]]; then
				etc_xinetd_permission=`stat -c %03a /etc/inetd.conf`
				etc_xinetd_owner_permission=`stat -c %03a /etc/xinetd.conf | cut -c1`
				etc_xinetd_group_permission=`stat -c %03a /etc/xinetd.conf | cut -c2`
				etc_xinetd_other_permission=`stat -c %03a /etc/xinetd.conf | cut -c3`
				if [ $etc_xinetd_owner_permission -eq 0 ] || [ $etc_xinetd_owner_permission -eq 2 ] || [ $etc_xinetd_owner_permission -eq 4 ] || [ $etc_xinetd_owner_permission -eq 6 ]; then
					if [ $etc_xinetd_group_permission -eq 0 ]; then
						if [ $etc_xinetd_other_permission -eq 0 ]; then
							echo -en "[양호]\t" >> $rf 2>&1
							echo " /etc/xinetd.conf 파일의 소유자가 root이고, 권한이 600인 이하인 상태입니다." >> $rf 2>&1
							return 0
						fi
					fi
				fi
				echo -en "[취약]\t" >> $rf 2>&1
				echo -en " /etc/xinetd.conf 파일에 대한 권한이 ${etc_xinetd_permission} 으로 취약한 상태입니다.\t" >> $rf 2>&1
				echo "주요정보통신기반시설 가이드를 참고하시어 /etc/xinetd.conf 파일 권한을 600(-rw-------) 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
				return 0
			else
				echo -en "[취약]\t" >> $rf 2>&1
				echo -en " /etc/xinetd.conf 파일의 소유자(owner)가 root가 아닌 상태입니다.\t" >> $rf 2>&1
				echo "주요정보통신기반시설 가이드를 참고하시어 /etc/xinetd.conf 파일의 소유자(owner)를 root로 설정하여 주시기 바랍니다." >> $rf 2>&1
				return 0
			fi
		else
			echo -en "[N/A]\t" >> $rf 2>&1
			echo " /etc/(x)inetd.conf 파일이 없는 상태입니다." >> $rf 2>&1
			return 0
		fi
	fi
}

U_11() {
	echo -en "U-11(상)\t2. 파일 및 디렉토리 관리\t2.7 /etc/syslog.conf 파일 소유자 및 권한 설정\t"  >> $rf 2>&1
	echo -en " /etc/syslog.conf 파일의 소유자가 root(또는 bin, sys)이고, 권한이 640 이하인 경우\t"  >> $rf 2>&1
	syslogconf_files=("/etc/rsyslog.conf" "/etc/syslog.conf" "/etc/syslog-ng.conf")
	file_exists_count=0
	judg=0
	wrong_owner=0
	for ((i=0; i<${#syslogconf_files[@]}; i++))
	do
		if [ -f ${syslogconf_files[$i]} ]; then
			((file_exists_count++))
			syslogconf_file_owner_name=`ls -l ${syslogconf_files[$i]} | awk '{print $3}'`
			if [[ $syslogconf_file_owner_name = root ]] || [[ $syslogconf_file_owner_name = bin ]] || [[ $syslogconf_file_owner_name = sys ]]; then
				syslogconf_file_owner_permission=`stat -c %03a ${syslogconf_files[$i]} | cut -c1`
				syslogconf_file_group_permission=`stat -c %03a ${syslogconf_files[$i]} | cut -c2`
				syslogconf_file_other_permission=`stat -c %03a ${syslogconf_files[$i]} | cut -c3`
				if [ $syslogconf_file_owner_permission -eq 0 ] || [ $syslogconf_file_owner_permission -eq 2 ] || [ $syslogconf_file_owner_permission -eq 4 ] || [ $syslogconf_file_owner_permission -eq 6 ]; then
					if [ $syslogconf_file_group_permission -eq 0 ] || [ $syslogconf_file_group_permission -eq 2 ] || [ $syslogconf_file_group_permission -eq 4 ]; then
						if [ $syslogconf_file_other_permission -eq 0 ]; then
							((judg++))
						fi
					fi
				fi
			else
				((wrong_owner++))
			fi
		fi
	done
	if [ $file_exists_count -eq 0 ]; then
		echo -en "[N/A]\t" >> $rf 2>&1
		echo " /etc/syslog.conf 파일이 없는 상태입니다." >> $rf 2>&1
		return 0
	else
		if [ $judg -eq $file_exists_count ]; then
			echo -en "[양호]\t" >> $rf 2>&1
			echo " /etc/syslog.conf 파일의 소유자가 root(또는 bin, sys)이고, 권한이 640 이하인 상태입니다." >> $rf 2>&1
			return 0
		else
			echo -en "[취약]\t" >> $rf 2>&1
			if [ $wrong_owner -eq 0 ]; then
				for ((i=0; i<${#syslogconf_files[@]}; i++))
				do
					if [ -f ${syslogconf_files[$i]} ]; then
						syslogconf_file_permission=`stat -c %03a ${syslogconf_files[$i]}`
						syslogconf_file_owner_permission=`stat -c %03a ${syslogconf_files[$i]} | cut -c1`
						syslogconf_file_group_permission=`stat -c %03a ${syslogconf_files[$i]} | cut -c2`
						syslogconf_file_other_permission=`stat -c %03a ${syslogconf_files[$i]} | cut -c3`
						if [ $syslogconf_file_owner_permission -eq 0 ] || [ $syslogconf_file_owner_permission -eq 2 ] || [ $syslogconf_file_owner_permission -eq 4 ] || [ $syslogconf_file_owner_permission -eq 6 ]; then
							if [ $syslogconf_file_group_permission -eq 0 ] || [ $syslogconf_file_group_permission -eq 2 ] || [ $syslogconf_file_group_permission -eq 4 ]; then
								if [ $syslogconf_file_other_permission -eq 0 ]; then
									continue
								fi
							fi
						fi
						echo -n " ${syslogconf_files[$i]} 파일에 대한 권한이 ${syslogconf_file_permission} 으로 취약한 상태입니다." >> $rf 2>&1
					fi
				done
				echo -en "\t" >> $rf 2>&1
				for ((i=0; i<${#syslogconf_files[@]}; i++))
				do
					if [ -f ${syslogconf_files[$i]} ]; then
						syslogconf_file_owner_permission=`stat -c %03a ${syslogconf_files[$i]} | cut -c1`
						syslogconf_file_group_permission=`stat -c %03a ${syslogconf_files[$i]} | cut -c2`
						syslogconf_file_other_permission=`stat -c %03a ${syslogconf_files[$i]} | cut -c3`
						if [ $syslogconf_file_owner_permission -eq 0 ] || [ $syslogconf_file_owner_permission -eq 2 ] || [ $syslogconf_file_owner_permission -eq 4 ] || [ $syslogconf_file_owner_permission -eq 6 ]; then
							if [ $syslogconf_file_group_permission -eq 0 ] || [ $syslogconf_file_group_permission -eq 2 ] || [ $syslogconf_file_group_permission -eq 4 ]; then
								if [ $syslogconf_file_other_permission -eq 0 ]; then
									continue
								fi
							fi
						fi
						echo -n "주요정보통신기반시설 가이드를 참고하시어  ${syslogconf_files[$i]} 파일 권한을 640(-rw-r-----) 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
					fi
				done
				echo "" >> $rf 2>&1
				return 0
			else
				for ((i=0; i<${#syslogconf_files[@]}; i++))
				do
					if [ -f ${syslogconf_files[$i]} ]; then
						syslogconf_file_owner_name=`ls -l ${syslogconf_files[$i]} | awk '{print $3}'`
						if [[ $syslogconf_file_owner_name =~ root ]] || [[ $syslogconf_file_owner_name =~ bin ]] || [[ $syslogconf_file_owner_name =~ sys ]]; then	
							echo -n " ${syslogconf_files[$i]} 파일의 소유자(owner)가 root(또는 bin, sys)가 아닌 상태입니다." >> $rf 2>&1
						fi
					fi
				done
				echo -e "\t" >> $rf 2>&1
				for ((i=0; i<${#syslogconf_files[@]}; i++))
				do
					if [ -f ${syslogconf_files[$i]} ]; then
						syslogconf_file_owner_name=`ls -l ${syslogconf_files[$i]} | awk '{print $3}'`
						if [[ $syslogconf_file_owner_name =~ root ]] || [[ $syslogconf_file_owner_name =~ bin ]] || [[ $syslogconf_file_owner_name =~ sys ]]; then	
							echo -n "주요정보통신기반시설 가이드를 참고하시어  ${syslogconf_files[$i]} 파일의 소유자(owner)가 root(또는 bin, sys)로 설정하여 주시기 바랍니다." >> $rf 2>&1
						fi
					fi
				done
				echo "" >> $rf 2>&1
				return 0
			fi
		fi
	fi
}

U_12() {
	echo -en "U-12(상)\t2. 파일 및 디렉토리 관리\t2.8 /etc/services 파일 소유자 및 권한 설정\t"  >> $rf 2>&1
	echo -en " /etc/services 파일의 소유자가 root(또는 bin, sys)이고, 권한이 644 이하인 경우\t"  >> $rf 2>&1
	if [ -f /etc/services ]; then
		etc_services_owner_name=`ls -l /etc/services | awk '{print $3}'`
		if [[ $etc_services_owner_name =~ root ]] || [[ $etc_services_owner_name =~ bin ]] || [[ $etc_services_owner_name =~ sys ]]; then
			etc_services_permission=`stat -c %03a /etc/services`
			etc_services_owner_permission=`stat -c %03a /etc/services | cut -c1`
			etc_services_group_permission=`stat -c %03a /etc/services | cut -c2`
			etc_services_other_permission=`stat -c %03a /etc/services | cut -c3`
			if [ $etc_services_owner_permission -eq 0 ] || [ $etc_services_owner_permission -eq 2 ] || [ $etc_services_owner_permission -eq 4 ] || [ $etc_services_owner_permission -eq 6 ]; then
				if [ $etc_services_group_permission -eq 0 ] || [ $etc_services_group_permission -eq 2 ] || [ $etc_services_group_permission -eq 4 ]; then
					if [ $etc_services_other_permission -eq 0 ] || [ $etc_services_other_permission -eq 2 ] || [ $etc_services_other_permission -eq 4 ]; then
						echo -en "[양호]\t" >> $rf 2>&1
						echo " /etc/services 파일의 소유자가 root(또는 bin, sys)이고, 권한이 644 이하인 상태입니다." >> $rf 2>&1
						return 0
					fi
				fi
			fi
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/services 파일에 대한 권한이 ${etc_services_permission} 으로 취약한 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/services 파일 권한을 644(-rw-r--r--) 이하로 설정하여 주시기 바랍니다." >> $rf 2>&1
		else
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/services 파일의 파일의 소유자(owner)가 root(또는 bin, sys)가 아닌 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /etc/services 파일의 소유자(owner)를 root로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		fi
	else
		echo -en "[N/A]\t" >> $rf 2>&1
		echo " /etc/services 파일이 없습니다." >> $rf 2>&1
		return 0
	fi
}

U_13() {
	echo -en "U-13(상)\t2. 파일 및 디렉토리 관리\t2.9 SUID, SGID, 설정 파일점검\t"  >> $rf 2>&1
	echo -en "주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우\t"  >> $rf 2>&1
	executables=("/sbin/dump" "/sbin/restore" "/sbin/unix_chkpwd" "/usr/bin/at" "/usr/bin/lpq" "/usr/bin/lpq-lpd" "/usr/bin/lpr" "/usr/bin/lpr-lpd" "/usr/bin/lprm" "/usr/bin/lprm-lpd" "/usr/bin/newgrp" "/usr/sbin/lpc" "/usr/sbin/lpc-lpd" "/usr/sbin/traceroute")
	for ((i=0; i<${#executables[@]}; i++))
	do
		if [ -f ${executables[$i]} ]; then
			if [ `ls -l ${executables[$i]} | awk '{print substr($1,2,9)}' | grep -i 's' | wc -l` -gt 0 ]; then
				echo -en "[취약]\t" >> $rf 2>&1
				echo -en "주요 실행 파일의 권한에 SUID나 SGID에 대한 설정이 부여되어 있는 상태입니다.\t" >> $rf 2>&1
				echo "주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 상태입니다." >> $rf 2>&1
				return 0
			fi
		fi
	done
	echo -en "[양호]\t" >> $rf 2>&1
	echo "주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 상태입니다." >> $rf 2>&1
	return 0
}

U_14() {
	echo -en "U-14(상)\t2. 파일 및 디렉토리 관리\t2.10 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정\t"  >> $rf 2>&1
	echo -en "홈 디렉토리 환경변수 파일 소유자가 root 또는, 해당 계정으로 지정되어 있고, 홈 디렉토리 환경변수 파일에 root와 소유자만 쓰기 권한이 부여된 경우\t"  >> $rf 2>&1
	file_exists_count=0
	judg=0
	user_homedirectory_paths=($(cat /etc/passwd | grep bash | awk -F: '{print $6}'))
	for user_homedirectory_path in "${user_homedirectory_paths}"
	do
		((file_exists_count++))
		for user_homedirectory_file in ${user_homedirectory_path}/.bash*
		do
			user_homedirectory_file_owner=$(stat -c %U ${user_homedirectory_file})
			owner_compare=($(cat /etc/passwd | grep bash | grep ${user_homedirectory_path} | awk -F: '{print $1}'))
			user_homedirectory_file_group_permission=$(stat -c %03a ${user_homedirectory_file} | cut -c2)
			user_homedirectory_file_other_permission=$(stat -c %03a ${user_homedirectory_file} | cut -c3)
			if [[ $user_homedirectory_file_owner -eq $owner_compare ]] || [[ $user_homedirectory_file_owner = root ]]; then
				if [ $user_homedirectory_file_group_permission -eq 0 ] || [ $user_homedirectory_file_group_permission -eq 1 ] || [ $user_homedirectory_file_group_permission -eq 4 ] || [ $user_homedirectory_file_group_permission -eq 5 ]; then
					if [ $user_homedirectory_file_other_permission -eq 0 ] || [ $user_homedirectory_file_other_permission -eq 1 ] || [ $user_homedirectory_file_other_permission -eq 4 ] || [ $user_homedirectory_file_other_permission -eq 5 ]; then
						continue
					fi
				fi
			fi
			((judg++))
		done
	done
	if [ $file_exists_count -eq 0 ]; then
		echo -en "[N/A]\t" >> $rf 2>&1
		echo "홈 디렉토리 환경변수 파일이 없는 상태입니다." >> $rf 2>&1
		return 0
	else
		if [ $judg -eq 0 ]; then
			echo -en "[양호]\t" >> $rf 2>&1
			echo "로그인이 가능한 모든 사용자의 환경변수 파일 소유자가 자기 자신으로 설정되어 있고 타사용자 쓰기권한이 부여되어 있지 않은 상태입니다." >> $rf 2>&1
			return 0
		else
			echo -en "[취약]\t" >> $rf 2>&1
			for user_homedirectory_path in "${user_homedirectory_paths}"
			do
				for user_homedirectory_file in ${user_homedirectory_path}/.bash*
				do
					user_homedirectory_file_owner=$(stat -c %U ${user_homedirectory_file})
					owner_compare=($(cat /etc/passwd | grep bash | grep ${user_homedirectory_path} | awk -F: '{print $1}'))
					user_homedirectory_file_group_permission=$(stat -c %03a ${user_homedirectory_file} | cut -c2)
					user_homedirectory_file_other_permission=$(stat -c %03a ${user_homedirectory_file} | cut -c3)
					if [[ $user_homedirectory_file_owner -eq $owner_compare ]] || [[ $user_homedirectory_file_owner = root ]]; then
						if [ $user_homedirectory_file_group_permission -eq 0 ] || [ $user_homedirectory_file_group_permission -eq 1 ] || [ $user_homedirectory_file_group_permission -eq 4 ] || [ $user_homedirectory_file_group_permission -eq 5 ]; then
							if [ $user_homedirectory_file_other_permission -eq 0 ] || [ $user_homedirectory_file_other_permission -eq 1 ] || [ $user_homedirectory_file_other_permission -eq 4 ] || [ $user_homedirectory_file_other_permission -eq 5 ]; then
								continue
							fi
						fi
						echo -n " ${user_homedirectory_file} 파일이 root와 소유자 외에 쓰기 권한이 부여된 상태입니다." >> $rf 2>&1
					else
						echo -n " ${user_homedirectory_file} 파일의 소유자가 root 또는, 해당 계정으로 지정되지 않은 상태입니다." >> $rf 2>&1
					fi
				done
			done
			echo -en "\t" >> $rf 2>&1
			for user_homedirectory_path in "${user_homedirectory_paths}"
			do
				for user_homedirectory_file in ${user_homedirectory_path}/.bash*
				do
					user_homedirectory_file_owner=$(stat -c %U ${user_homedirectory_file})
					owner_compare=($(cat /etc/passwd | grep bash | grep ${user_homedirectory_path} | awk -F: '{print $1}'))
					user_homedirectory_file_group_permission=$(stat -c %03a ${user_homedirectory_file} | cut -c2)
					user_homedirectory_file_other_permission=$(stat -c %03a ${user_homedirectory_file} | cut -c3)
					if [[ $user_homedirectory_file_owner -eq $owner_compare ]] || [[ $user_homedirectory_file_owner = root ]]; then
						if [ $user_homedirectory_file_group_permission -eq 0 ] || [ $user_homedirectory_file_group_permission -eq 1 ] || [ $user_homedirectory_file_group_permission -eq 4 ] || [ $user_homedirectory_file_group_permission -eq 5 ]; then
							if [ $user_homedirectory_file_other_permission -eq 0 ] || [ $user_homedirectory_file_other_permission -eq 1 ] || [ $user_homedirectory_file_other_permission -eq 4 ] || [ $user_homedirectory_file_other_permission -eq 5 ]; then
								continue
							fi
						fi
						echo -n "주요정보통신기반시설 가이드를 참고하시어 ${user_homedirectory_file} 파일의 root와 소유자 외에 쓰기 권한을 제거하여 주시기 바랍니다." >> $rf 2>&1
					else
						echo -n "주요정보통신기반시설 가이드를 참고하시어 ${user_homedirectory_file} 파일의 소유자가 root 또는, 해당 계정으로 지정하여 주시기 바랍니다." >> $rf 2>&1
					fi
				done
			done
			echo "" >> $rf 2>&1
			return 0
		fi
	fi
}

U_15() {
	echo -en "U-15(상)\t2. 파일 및 디렉토리 관리\t2.11 world writable 파일 점검\t"  >> $rf 2>&1
	echo -en "시스템 중요 파일에 world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우\t"  >> $rf 2>&1
	if [ `find / ! \( -path '/proc*' -o -path '/sys/fs*' -o -path '/usr/local*' -prune \) -perm -2 -type f 2>/dev/null | wc -l` -gt 0 ]; then
		echo -en "[인터뷰]\t" >> $rf 2>&1
		echo " /root 디렉터리 내 타사용자 쓰기권한이 부여된 파일이 존재하여 불필요하게 권한이 부여되어 있지 않은지 담당자 확인이 필요합니다." >> $rf 2>&1
		return 0
	else
		echo -en "[양호]\t" >> $rf 2>&1
		echo "world writable 파일이 존재하지 않은 상태입니다." >> $rf 2>&1
		return 0
	fi
}

U_16() {
	echo -en "U-16(상)\t2. 파일 및 디렉토리 관리\t2.12 /dev에 존재하지 않는 device 파일 점검 "  >> $rf 2>&1
	echo -en " /dev에 대한 파일 점검 후 존재하지 않은 device 파일을 제거한 경우\t" >> $rf 2>&1
	if [ `find /dev -type f 2>/dev/null | wc -l` -gt 0 ]; then
		echo -en "[인터뷰]\t" >> $rf 2>&1
		echo " /dev 디렉터리 내 불필요하게 사용되고 있는 디바이스 파일이 존재하는지 담당자 확인이 필요합니다." >> $rf 2>&1
		return 0
	else
		echo -en "[양호]\t" >> $rf 2>&1
		echo "world writable 파일이 존재하지 않은 상태입니다." >> $rf 2>&1
		return 0
	fi
}


U_18() {
	echo -en "U-18(상)\t2. 파일 및 디렉토리 관리\t2.14 접속 IP 및 포트 제한\t"  >> $rf 2>&1
	echo -en "접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정한 경우\t" >> $rf>&1
	if [ -f /etc/hosts.deny ]; then
		etc_hostsdeny_allall_count=`grep -vE '^#|^\s#' /etc/hosts.deny | awk '{gsub(" ", "", $0); print}' | grep -i 'all:all' | wc -l`
		if [ $etc_hostsdeny_allall_count -gt 0 ]; then
			if [ -f /etc/hosts.allow ]; then
				etc_hostsallow_allall_count=`grep -vE '^#|^\s#' /etc/hosts.allow | awk '{gsub(" ", "", $0); print}' | grep -i 'all:all' | wc -l`
				if [ $etc_hostsallow_allall_count -gt 0 ]; then
					echo -en "[취약]\t" >> $rf 2>&1
					echo -en " /etc/hosts.allow 파일에 'ALL : ALL' 설정이 있는 상태입니다.\t" >> $rf 2>&1
					echo "주요정보통신기반시설 가이드를 참고하시어 접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정하여 주시기 바랍니다." >> $rf 2>&1
					return 0
				else
					echo -en "[양호]\t" >> $rf 2>&1
					echo "접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정되어 있는 상태입니다." >> $rf 2>&1
					return 0
				fi
			else
				echo -en "[양호]\t" >> $rf 2>&1
				echo "접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정되어 있는 상태입니다." >> $rf 2>&1
				return 0
			fi
		else
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/hosts.deny 파일에 'ALL : ALL' 설정이 없는 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		fi
	else
		echo -en "[인터뷰]\t" >> $rf 2>&1
		echo " /etc/hosts.deny 파일이 없는 상태입니다.서버접근제어 솔루션 및 내부 방화벽을 통해 서버 접근을 통제하고 있는지 담당자 확인이 필요합니다." >> $rf 2>&1
		return 0
	fi
}

U_55() {
	echo -en "U-55(하)\t2. 파일 및 디렉토리 관리\t2.15 hosts.lpd 파일 소유자 및 권한 설정\t"  >> $rf 2>&1
	echo -en "hosts.lpd 파일이 삭제되어 있거나 불가피하게 hosts.lpd 파일을 사용할 시 파일의 소유자가 root이고 권한이 600 이하인 경우\t" >> $rf 2>&1
	if [ -f /etc/hosts.lpd ]; then
		etc_hostslpd_owner_name=`ls -l /etc/hosts.lpd | awk '{print $3}'`
		if [[ $etc_hostslpd_owner_name = root ]]; then
			etc_hostslpd_permission=`stat -c %03a /etc/hosts.lpd`
			if [ $etc_hostslpd_permission -eq 600 ] || [ $etc_hostslpd_permission -eq 400 ] || [ $etc_hostslpd_permission -eq 200 ] || [ $etc_hostslpd_permission -eq 000 ]; then
				echo -en "[양호]\t" >> $rf 2>&1
				echo " /hosts.lpd 파일의 소유자가 root이고 권한이 600 이하인 상태입니다." >> $rf 2>&1
				return 0
			else
				echo -en "[취약]\t" >> $rf 2>&1
				echo -en " /etc/hosts.lpd 파일의 권한이 ${etc_hostslpd_permission}으로 취약한 상태입니다.\t" >> $rf 2>&1
				echo "주요정보통신기반시설 가이드를 참고하시어 /hosts.lpd 파일 권한을 600(-rw-------) 이하로 설정하거나 삭제하여 주시기 바랍니다." >> $rf 2>&1
				return 0
			fi
		else
			echo -en "[취약]\t" >> $rf 2>&1
			echo -en " /etc/hosts.lpd 파일의 소유자(owner)가 root가 아닌 상태입니다.\t" >> $rf 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 /hosts.lpd 파일의 소유자(owner)를 root로 설정하여 주시기 바랍니다." >> $rf 2>&1
			return 0
		fi
	else
		echo -en "[양호]\t" >> $rf 2>&1
		echo " /etc/hosts.lpd 파일이 존재하지 않는 상태입니다." >> $rf 2>&1
		return 0
	fi
}

U_56() {
	echo -en "U-56(중)\t2. 파일 및 디렉토리 관리\t2.17 UMASK 설정 관리"  >> $rf 2>&1
	echo -en "UMASK 값이 022 이상으로 설정된 경우\t" >> $rf 2>&1
	profile_umasks_num=($(cat /etc/profile | grep umask | grep -vE '^#|^\s#' | awk '{print $NF}' | wc -l))
	if [ $profile_umasks_num -eq 0 ]; then
		echo -en "[취약]\t" >> $rf 2>&1
		echo -en "UMASK 값이 설정되어 있지 않은 상태입니다.\t" >> $rf 2>&1
		echo "주요정보통신기반시설 가이드를 참고하시어 UMASK 값이 022 이상으로 설정하여 주시기 바랍니다." >> $rf 2>&1
		return 0
	else
		profile_umasks=($(cat /etc/profile | grep umask | grep -vE '^#|^\s#' | awk '{print $NF}'):1:1)
		for umask_value in "${profile_umasks[@]}"
		do
			umask_string=$(echo "$umask_value")
			if [ ${umask_string:1:1} -eq 0 ] || [ ${umask_string:1:1} -eq 1 ] || [ ${umask_string:1:1} -eq 4 ] || [ ${umask_string:1:1} -eq 5 ]; then
				echo -en "[취약]\t" >> $rf 2>&1
				echo -en "UMASK 값이 022 이상으로 설정되지 않은 상태입니다.\t" >> $rf 2>&1
				echo "주요정보통신기반시설 가이드를 참고하시어 UMASK 값이 022 이상으로 설정하여 주시기 바랍니다." >> $rf 2>&1
				return 0
			else
				if [ ${umask_string:2:1} -eq 0 ] || [ ${umask_string:2:1} -eq 1 ] || [ ${umask_string:2:1} -eq 4 ] || [ ${umask_string:2:1} -eq 5 ]; then
					echo -en "[취약]\t" >> $rf 2>&1
					echo -en "UMASK 값이 022 이상으로 설정되지 않은 상태입니다.\t" >> $rf 2>&1
					echo "주요정보통신기반시설 가이드를 참고하시어 UMASK 값이 022 이상으로 설정하여 주시기 바랍니다." >> $rf 2>&1
					return 0
				fi
			fi
		done
		echo -en "[양호]\t" >> $rf 2>&1
		echo "UMASK 값이 022 이상으로 설정되어 있는 상태입니다." >> $rf 2>&1
		return 0
	fi
}

U_57() {
	echo -en "U-57(중)\t2. 파일 및 디렉토리 관리\t2.18 홈디렉토리 소유자 및 권한 설정\t"  >> $rf 2>&1
	echo -en "홈 디렉터리 소유자가 해당 계정이고, 타 사용자 쓰기 권한이 제거된 경우\t" >> $rf 2>&1
	file_exists_count=0
	judg=0
	user_homedirectory_paths=($(cat /etc/passwd | grep bash | awk -F: '{print $6}'))
	for user_homedirectory_path in "${user_homedirectory_paths}"
	do
		((file_exists_count++))
		for user_homedirectory_file in ${user_homedirectory_path}
		do
			user_homedirectory_file_owner=$(stat -c %U ${user_homedirectory_file})
			owner_compare=($(cat /etc/passwd | grep bash | grep ${user_homedirectory_path} | awk -F: '{print $1}'))
			user_homedirectory_file_other_permission=$(stat -c %03a ${user_homedirectory_file} | cut -c3)
			if [[ $user_homedirectory_file_owner -eq $owner_compare ]]; then
				if [ $user_homedirectory_file_other_permission -eq 0 ] || [ $user_homedirectory_file_other_permission -eq 1 ] || [ $user_homedirectory_file_other_permission -eq 4 ] || [ $user_homedirectory_file_other_permission -eq 5 ]; then
					continue
				fi
			fi
			((judg++))
		done
	done
	if [ $file_exists_count -eq 0 ]; then
		echo -en "[N/A]\t" >> $rf 2>&1
		echo "홈 디렉토리 환경변수 파일이 없는 상태입니다." >> $rf 2>&1
		return 0
	else
		if [ $judg -eq 0 ]; then
			echo -en "[양호]\t" >> $rf 2>&1
			echo "로그인이 가능한 사용자 홈 디렉터리의 소유주가 자기 자신이고, 타사용자 쓰기 권한이 부여되어 있지 않은 상태입니다." >> $rf 2>&1
			return 0
		else
			echo -en "[취약]\t" >> $rf 2>&1
			for user_homedirectory_path in "${user_homedirectory_paths}"
			do
				for user_homedirectory_file in ${user_homedirectory_path}/.bash*
				do
					user_homedirectory_file_owner=$(stat -c %U ${user_homedirectory_file})
					owner_compare=($(cat /etc/passwd | grep bash | grep ${user_homedirectory_path} | awk -F: '{print $1}'))
					user_homedirectory_file_other_permission=$(stat -c %03a ${user_homedirectory_file} | cut -c3)
					if [[ $user_homedirectory_file_owner -eq $owner_compare ]]; then
						if [ $user_homedirectory_file_other_permission -eq 0 ] || [ $user_homedirectory_file_other_permission -eq 1 ] || [ $user_homedirectory_file_other_permission -eq 4 ] || [ $user_homedirectory_file_other_permission -eq 5 ]; then
							continue
						fi
						echo -n " ${user_homedirectory_file} 파일이 타사용자 쓰기 권한이 부여되어 있는 상태입니다." >> $rf 2>&1
					else
						echo -n " ${user_homedirectory_file} 파일의 소유자가 해당 계정으로 지정되지 않은 상태입니다." >> $rf 2>&1
					fi
				done
			done
			echo -en "\t" >> $rf 2>&1
			for user_homedirectory_path in "${user_homedirectory_paths}"
			do
				for user_homedirectory_file in ${user_homedirectory_path}/.bash*
				do
					user_homedirectory_file_owner=$(stat -c %U ${user_homedirectory_file})
					owner_compare=($(cat /etc/passwd | grep bash | grep ${user_homedirectory_path} | awk -F: '{print $1}'))
					user_homedirectory_file_other_permission=$(stat -c %03a ${user_homedirectory_file} | cut -c3)
					if [[ $user_homedirectory_file_owner -eq $owner_compare ]]; then
						if [ $user_homedirectory_file_other_permission -eq 0 ] || [ $user_homedirectory_file_other_permission -eq 1 ] || [ $user_homedirectory_file_other_permission -eq 4 ] || [ $user_homedirectory_file_other_permission -eq 5 ]; then
							continue
						fi
						echo -n "주요정보통신기반시설 가이드를 참고하시어 ${user_homedirectory_file} 파일의 타사용자 쓰기 권한을 제거하여 주시기 바랍니다." >> $rf 2>&1
					else
						echo -n "주요정보통신기반시설 가이드를 참고하시어 ${user_homedirectory_file} 파일의 소유자가 해당 계정으로 지정하여 주시기 바랍니다." >> $rf 2>&1
					fi
				done
			done
			echo "" >> $rf 2>&1
			return 0
		fi
	fi
}

U_58() {
	echo -en "U-58(중)\t2. 파일 및 디렉토리 관리\t2.19 홈디렉토리로 지정한 디렉토리의 존재 관리\t"  >> $rf 2>&1
	echo -en "홈 디렉터리가 존재하지 않는 계정이 발견되지 않는 경우\t" >> $rf 2>&1
	judg=0
	user_homedirectory_paths=($(cat /etc/passwd | grep bash | awk -F: '{print $6}'))
	for user_homedirectory_path in "${user_homedirectory_paths}"
	do
		if [ -f ${user_homedirectory_path} ]; then
			continue
		else
			((judg++))
		fi
	done
	if [ $judg -eq 0 ]; then
		echo -en "[양호]\t" >> $rf 2>&1
		echo "모든 계정이 홈 디렉토리가 존재하는 상태입니다." >> $rf 2>&1
		return 0
	else
		echo -en "[취약]\t" >> $rf 2>&1
		user_name=($(cat /etc/passwd | grep bash | grep ${user_homedirectory_path} | awk -F: '{print $1}'))
		for user_homedirectory_path in "${user_homedirectory_paths}"
		do
			if [ -f ${user_homedirectory_path} ]; then
				continue
			else
				echo -n " ${user_name} 계정의 홈 디렉토리가 존재하지 않는 상태입니다." >> $rf 2>&1
			fi
		done
		echo -en "\t" >> $rf 2>&1
		for user_homedirectory_path in "${user_homedirectory_paths}"
		do
			if [ -f ${user_homedirectory_path} ]; then
				continue
			else
				echo -n "주요정보통신기반시설 가이드를 참고하시어 ${user_name} 계정에 홈 디렉토리를 지정하여 주시기 바랍니다." >> $rf 2>&1
			fi
		done
		echo "" >> $rf 2>&1
		return 0
	fi
}

U_59() {
	echo -en "U-59(하)\t2. 파일 및 디렉토리 관리\t2.20 숨겨진 파일 및 디렉토리 검색 및 제거\t"  >> $rf 2>&1
	echo -en " 불필요하거나 의심스러운 숨겨진 파일 및 디렉터리를 삭제한 경우\t" >> $rf 2>&1
	if [ `find / -name '.*' -type f 2>/dev/null | wc -l` -gt 0 ]; then
		echo -en "[인터뷰]\t" >> $rf 2>&1
		echo "로그인이 가능한 사용자 홈 디렉터리 내 숨겨지거나 불필요한 파일이 존재하는지 담당자 확인이 필요합니다." >> $rf 2>&1
		return 0
	elif [ `find / -name '.*' -type d 2>/dev/null | wc -l` -gt 0 ]; then
		echo -en "[인터뷰]\t" >> $rf 2>&1
		echo "로그인이 가능한 사용자 홈 디렉터리 내 숨겨지거나 불필요한 파일이 존재하는지 담당자 확인이 필요합니다." >> $rf 2>&1
		return 0
	else
		echo -en "[양호]\t" >> $rf 2>&1
		echo "불필요하거나 의심스러운 숨겨진 파일 및 디렉토리가 존재하지 않은 상태입니다." >> $rf 2>&1
		return 0
	fi
}

U_05
U_06
U_07
U_08
U_09
U_10
U_11
U_12
U_13
U_14
U_15
U_16
U_18
U_55
U_56
U_57
U_58
U_59