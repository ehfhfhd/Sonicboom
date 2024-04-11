U_24() {
    echo -en "U-24(상)\t3. 서비스  관리\t3.6 NFS 서비스 비활성화\t" >> $rf 2>&1
    echo -en "불필요한 NFS 서비스 사용여부 점검\t" >> $rf 2>&1

    if ps aux | grep -q "[n]fs" && ps aux | grep -q "[r]pc.statd" && ps aux | grep -q "[r]pc.lockd"; then
        echo -en "[취약]\t" >> $rf 2>&1
        echo -en "불필요한 NFS 서비스 관련 데몬 중 하나 이상이 활성화 되어 있는 상태입니다.\t" >> $rf 2>&1
        echo "주요정보통신기반시설 가이드를 참고하시어 해당 서비스를 비활성화하여 주시기 바랍니다." >> $rf 2>&1
    else
        echo -en "[양호]\t" >> $rf 2>&1
        echo "불필요한 NFS 서비스 관련 데몬이 비활성화 되어 있는 상태입니다." >> $rf 2>&1
    fi
}