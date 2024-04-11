#!/bin/bash

rf="/root/test_1/result_34"

U_34() {
    echo -en "U-34(상)\t3. 서비스  관리\t3.16 DNS Zone Transfer\t"  >> $rf 2>&1
    echo -en "Secondary Name Server로만 Zone 정보 전송 제한 여부 점검\t"  >> $rf 2>&1

    ps_chk=`bash ps_chk.sh named`
    all_chk=`cat /etc/bind/named.conf | grep 'allow-transfer' | wc -l`
    xtf_chk=`cat /etc/bind/named.conf | grep 'xfrnets' | wc -l`
    count=0

    if [ $ps_chk != 0 ];then

        if [ $all_chk = 0 ];then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "allow-transfer 옵션이 비활성화되어 있는 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 allow-transfer 옵션을 활성화하여 주시기 바랍니다." >> $rf 2>&1
            count=`expr $count + 1`
        fi

        if [ $xtf_chk = 0 ];then
            echo -en "[취약]\t" >> $rf 2>&1
            echo -en "xfrnets 옵션이 비활성화되어 있는 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 xfrnets 옵션을 활성화하여 주시기 바랍니다." >> $rf 2>&1
            count=`expr $count + 1`
        fi

        if [ $count = 0 ];then
            echo -en "[양호]\t" >> $rf 2>&1
            echo "named 데몬이 비활성화되어 있는 상태입니다." >> $rf 2>&1
        fi
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "named 데몬이 비활성화되어 있는 상태입니다." >> $rf 2>&1
        return 0
    fi
}

U_34