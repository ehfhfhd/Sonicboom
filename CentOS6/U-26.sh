U_26() {
    echo -en "U-26(상)\t3. 서비스  관리\t3.8 automountd 제거\t" >> $rf 2>&1
    echo -en "automountd 서비스 데몬의 실행 여부 점검\t" >> $rf 2>&1

    am_chk=$(ps -ef | grep automountd | grep -v grep | wc -l)

    if [ $am_chk -gt 0 ]; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "automountd 프로세스가 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 automountd 프로세스를 비활성화 해주시기 바랍니다." >> $rf 2>&1
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "automountd 프로세스가 비활성화되어 있는 상태입니다." >> $rf 2>&1
    fi
}