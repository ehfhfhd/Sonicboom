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