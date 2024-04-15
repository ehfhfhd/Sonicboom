U_33() {
    echo -en "U-33(상)\t3. 서비스  관리\t3.15 DNS 보안 버전 패치\t" >> $rf 2>&1
    echo -en "BIND 최신버전 사용 유무 및 주기적 보안 패치 여부 점검\t" >> $rf 2>&1

    # named 데몬이 실행 중인지 확인
	if pgrep named >/dev/null; then
		# RPM 패키지를 통해 BIND 버전 정보 확인
		rpm_bind9_minor_version=$(rpm -qa 2>/dev/null | grep '^bind' | awk -F '9.' '{print $2}' | grep -v '^$' | uniq)
		# BIND 버전 정보가 있는지 확인
		if [ -n "$rpm_bind9_minor_version" ]; then
			# RPM 패키지 버전을 확인
			for version in $rpm_bind9_minor_version; do
				if [[ $version =~ 18.* ]]; then
					rpm_bind9_patch_version=$(rpm -qa 2>/dev/null | grep '^bind' | awk -F '18.' '{print $2}' | grep -v '^$' | uniq)
					if [ -n "$rpm_bind9_patch_version" ]; then
						for patch_version in $rpm_bind9_patch_version; do
							if ! [[ $patch_version =~ [7-9]* ]] || ! [[ $patch_version =~ 1[0-6]* ]]; then
                                echo -en "[취약]\t" >> $rf 2>&1
                                echo -en "BIND 버전이 최신 버전이 아닌 상태입니다.\t" >> $rf 2>&1
                                echo "주요정보통신기반시설 가이드를 참고하시어 BIND 버전을 최신 버전으로 설정하여 주시기 바랍니다." >> $rf 2>&1
								return 0
							fi
						done
					fi
				fi
			done
		fi
		
		# DNS 서비스가 실행 중이지만 BIND 버전이 최신 버전이 아닌 경우
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "DNS 서비스가 활성화되어 있으며, BIND 버전이 최신 버전이 아닌 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 DNS 서비스를 비활성화하거나 BIND 버전을 최신 버전으로 설정하여 주시기 바랍니다." >> $rf 2>&1
		return 0
	fi

    echo -en "[양호]\t" >> $rf 2>&1
    echo "BIND 버전이 최신 버전인 상태입니다." >> $rf 2>&1
	return 0
}