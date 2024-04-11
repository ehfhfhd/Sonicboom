U_28() {
    echo -en "U-28(상)\t3. 서비스  관리\t3.10 NIS. NIS+ 점검\t" >> $rf 2>&1
    echo -en "불필요한 NFS 서비스 사용여부 점검\t" >> $rf 2>&1

    if [ `ps aux | egrep "ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated" | grep -v grep | wc -l` -gt 0 ]; then
	    echo -en "[취약]\t" >> $rf 2>&1
        echo -en "NIS 서비스가 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 NIS 서비스를 비활성화하여 주시기 바랍니다." >> $rf 2>&1
        return 0
    else
	    echo -en "[양호]\t" >> $rf 2>&1
        echo "NIS 서비스가 비활성화되어 있는 상태입니다." >> $rf 2>&1
        return 0
    fi
}
