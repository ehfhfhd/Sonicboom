U_34() {
    echo -en "U-34(상)\t3. 서비스  관리\t3.16 DNS Zone Transfer\t" >> $rf 2>&1
    echo -en "Secondary Name Server로만 Zone 정보 전송 제한 여부 점검\t" >> $rf 2>&1

    # named 데몬이 실행 중인지 확인
    if pgrep named >/dev/null; then
        # named.conf 파일에서 allow-transfer이 모든 사용자에게 허용되었는지 확인
        etc_namedconf_allowtransfer_count=$(grep -vE '^#|^\s#' /etc/named.conf | grep -i 'allow-transfer' | grep -i 'any' | wc -l)
        if [ "$etc_namedconf_allowtransfer_count" -gt 0 ]; then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "/etc/named.conf 파일에 allow-transfer { any; } 설정이 있는 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 allow-transfer 옵션을 허가된 사용자에게만 활성화하여 주시기 바랍니다." >> $rf 2>&1
            return 0
        fi
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "named 데몬이 비활성화되어 있는 상태입니다." >> $rf 2>&1
        return 0
    fi
}