rf="result.txt"
U_42() {
	echo -en "U-42(상)\t 4 패치 관리\t 4.1 최신 보안패치 및 벤더 권고사항 적용\t"  >> $rf 2>&1
	echo -en " 시스템에서 최신 패치가 적용되어 있는지 점검\t" >> $rf 2>&1
	
	echo -en "[취약]\t" >> $rf 2>&1
	rpm=$(rpm -qa | grep "openssh\|bash\|gblibc\|named\|openssl")
	rpm=$(echo "$rpm" | tr '\n' ' ')
	rpm="$rpm"$'\t'
	echo -en "$rpm" >> $rf 2>&1
	echo -en "현재 사용하고 있는 OS(CentOS6)는 이미 EOS(End Of Service)가 되어 CVE 주요 취약점이 발생할 수 있는 패키지에 대한 패키지에 대한 패치작업을 진행할 수 없는 상태입니다.\t" >> $rf 2>&1
    echo "주요정보통신기반시설 가이드를 참고하시어 주요 CVE 취약점 및 기타 취약점이 발생할 수 있는 패키지의 최신 패치 적용을 위해 OS를 상위 버전으로 신규 구축하여 주시기 바랍니다. ※ 서비스 및 시스템 영향도를 파악하시어 설정 적용하시기 바랍니다." >> $rf 2>&1
}
U_42