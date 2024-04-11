U_25() {
    echo -en "U-25(상)\t3. 서비스  관리\t3.7 NFS 접근 통제\t" >> $rf 2>&1
    echo -en "NFS(Network File System) 사용 시 허가된 사용자만 접속할 수 있도록 접근 제한 설정 적용 여부 점검\t" >> $rf 2>&1

    # NFS 서버가 설치되어 있는지 확인
    if rpm -q nfs-utils &>/dev/null; then
        nfs_config="/etc/exports"       
        # NFS 서버 설정 파일이 존재하는지 확인
        if [ -f "$nfs_config" ]; then
            # NFS 서버 설정 파일에서 접근 제어 설정 확인
            if grep -qE "^\s*[^#]+\s+\(/[^)]*\)\s*\([^\)]*sec=sys[ ,]*[^)]*no_?access[ ,]*\)" "$nfs_config"; then
                echo -en "[취약]\t" >> $rf 2>&1
                echo -en "NFS 서버 설정 파일에 everyone 공유를 제한하지 않은 불필요한 NFS 서비스가 설정되어 있는 상태입니다.\t" >> $rf 2>&1
                echo "주요정보통신기반시설 가이드를 참고하시어 NFS 서버 설정 파일에서 everyone 공유를 제한하는 설정을 추가하고 서비스를 다시 시작하여 주시기 바랍니다." >> $rf 2>&1
            else
                echo -en "[양호]\t" >> $rf 2>&1
                echo "NFS 서버 설정 파일에 불필요한 NFS 서비스가 비활성화 되어 있고, everyone 공유를 제한되어 있는 상태입니다." >> $rf 2>&1
            fi
        else
            echo -en "[취약]\t" >> $rf 2>&1
            echo "NFS 서버 설정 파일이 존재하지 않는 상태입니다." >> $rf 2>&1
        fi
    else
        echo -en "[취약]\t" >> $rf 2>&1
        echo "NFS 서버가 설치되어 있지 않은 상태입니다." >> $rf 2>&1
    fi
}