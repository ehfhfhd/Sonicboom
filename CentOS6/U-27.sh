U_27() {
    echo -en "U-27(상)\t3. 서비스  관리\t3.9 RPC 서비스 확인\t" >> $rf 2>&1
    echo -en "불필요한 RPC 서비스 실행 여부 점검\t" >> $rf 2>&1

    file_list=$(ls -A /etc/xinetd.d)
    count=0

    rpc_services=("rpc.cmsd" "rpc.ttdbserverd" "sadmind" "rusersd" "walld" "sprayd" "rstatd" "rpc.nisd" "rexd" "rpc.pcnfsd" "rpc.statd" "rpc.ypupdated" "rpc.rquotad" "kcms_server" "cachefsd")

    # 불필요한 RPC 서비스가 활성화 되어 있는 경우
    for rpc_service in "${rpc_services[@]}"; do
        process=$(ps -ef | grep -E "\b${rpc_service}\b" | grep -v grep)
        if [ -n "$process" ]; then
            owner=$(echo "$process" | awk '{print $1}')
            if [ "$owner" != "root" ]; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "불필요한 RPC 서비스($rpc_service)가 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 불필요한 RPC 서비스를 비활성화하여 주시기 바랍니다." >> $rf 2>&1
                return 0
            fi
        fi
    done

    # 모든 RPC 서비스가 비활성화 되어 있는 경우
    echo -en "[양호]\t" >> $rf 2>&1
    echo "불필요한 RPC 서비스가 비활성화 되어 있는 상태입니다." >> $rf 2>&1
    return 0
}