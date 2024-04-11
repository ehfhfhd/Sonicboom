U_23() {
    echo -en "U-23(상)\t3. 서비스  관리\t3.5 DoS 공격에 취약한 서비스 비활성화\t" >> $rf 2>&1
    echo -en "사용하지 않는 DoS 공격에 취약한 서비스의 실행 여부 점검\t" >> $rf 2>&1

    vulnerable_services=("echo" "discard" "daytime" "chargen")

    for service in "${vulnerable_services[@]}"; do
        if service $service status > /dev/null 2>&1; then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "$service 서비스가 실행 중인 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 $service 서비스를 중지하고 비활성화하여 주시기 바랍니다." >> $rf 2>&1
        fi
    done
    echo -en "[양호]\t" >> $rf 2>&1
    echo "echo, discard, daytime, chargen 서비스가 실행 중이지 않은 상태입니다." >> $rf 2>&1
}