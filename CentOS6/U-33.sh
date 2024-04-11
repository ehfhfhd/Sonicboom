#!/bin/bash

rf="/root/test_1/result_33"

U_33() {
    echo -en "U-31(상)\t3. 서비스  관리\t3.13 스팸 메일 릴레이 제한\t" >> $rf 2>&1
    echo -en "SMTP 서버의 릴레이 기능 제한 여부 점검\t" >> $rf 2>&1

    ps_chk=`ps -ef | grep named | grep -v grep | wc -l`
    ver_chk=`named -v 2>/dev/nill | awk -F " " '{print $2}' | awk -F "ubuntu" '{print $1}' | awk -F "-" '{print $1}' | tr -d "."`
    inst_chk=`named -v 2>/dev/null | wc -l`
    version=9113

    if [ $ps_chk != 0 ] && [ $inst_chk != 0 ];then

	    if [ $ver_chk -lt $version ];then
		    echo -en "[취약]\t" >> $rf 2>&1
            echo -en "BIND 버전이 최신 버전이 아닌 상태입니다.\t" >> $rf 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 BIND 버전을 최신 버전으로 설정하여 주시기 바랍니다." >> $rf 2>&1
            return 0 
	    else
		    echo -en "[양호]\t" >> $rf 2>&1
            echo -en "named 패키지가 설치되어 있는 상태입니다.\t" >> $rf 2>&1
            return 0
	    fi
    else
	    echo -en "[양호]\t" >> $rf 2>&1
        echo "named 패키지가 설치되어 있는 상태입니다." >> $rf 2>&1
        return 0
    fi
}

U_33