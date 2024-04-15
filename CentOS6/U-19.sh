U_19() {
    echo -en "U-19(상)\t3. 서비스 관리\t3.1 Finger 서비스 비활성화\t" >> $rf 2>&1
    echo -en "finger 서비스 비활성화 여부 점검\t" >> $rf 2>&1

    if ! command -v finger &>/dev/null; then
		echo -en "[양호]\t" >> $rf 2>&1
        echo "Finger 서비스가 비활성화되어 있는 상태입니다." >> $rf 2>&1
        return 0
	fi

    if grep -qs "finger" /etc/inetd.conf || grep -qs "finger" /etc/xinetd.conf; then
		echo -en "[취약]\t" >> $rf 2>&1
        echo -en "Finger 서비스가 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 Finger 서비스를 비활성화하여 주시기 바랍니다." >> $rf 2>&1
		return 0
	fi

	echo -en "[양호]\t" >> $rf 2>&1
    echo "Finger 서비스가 비활성화되어 있는 상태입니다." >> $rf 2>&1
    return 0
}