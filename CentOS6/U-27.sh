U_27() {
    echo -en "U-27(상)\t3. 서비스  관리\t3.9 RPC 서비스 확인\t" >> $rf 2>&1
    echo -en "불필요한 RPC 서비스 실행 여부 점검\t" >> $rf 2>&1

    file_list=$(ls -A /etc/xinetd.d)
    count=0
   
    for filename in $file_list; do
        if [ "$filename" != "." ] && [ "$filename" != ".." ]; then
            check_count=$(grep -vE '^#|^\s*' "/etc/xinetd.d/$filename" | grep -i 'disable' | awk -F "=" '{print $2}' | wc -w)
            check=$(grep -vE '^#|^\s*' "/etc/xinetd.d/$filename" | grep -i 'disable' | awk -F "=" '{print $2}' | grep -i 'yes' | wc -w)
           
            if [ "$check" -ne "$check_count" ]; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "불필요한 RPC 서비스(/etc/xinetd.d/$filename)가 활성화되어 있는 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 불필요한 RPC 서비스를 비활성화하여 주시기 바랍니다." >> $rf 2>&1
                count=$((count + 1))
            fi
        fi
    done
    
    if [ "$count" -eq 0 ]; then
        echo -en "[양호]\t" >> $rf 2>&1
        echo "불필요한 RPC 서비스가 비활성화 되어 있는 상태입니다." >> $rf 2>&1
    fi
}