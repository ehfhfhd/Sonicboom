#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-69(중)\t3. 서비스관리\t3.33 NFS 설정파일 접근권한\t" >> "$rf" 2>&1
echo -en "NFS 접근제어 설정파일 소유자가 root 이고, 권한이 644 이하인 경우\t" >> "$rf" 2>&1

# NFS 데몬 활성화 여부 확인
if ! ps -a | grep -qw "nfsd"; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "\"NFS\" 데몬이 비활성화되어 있는 상태입니다." >> "$rf" 2>&1
else
    # NFS 설정파일 점검
    file="/etc/exports"
    if [ -f "$file" ]; then
        owner=$(stat -c "%U" "$file")
        perms=$(stat -c "%a" "$file")

        # 권한이 644 이하인지 확인
        read_perms="${perms:0:1}"
        write_perms="${perms:1:1}"
        execute_perms="${perms:2:1}"

        if [[ "$owner" != "root" ]] || [[ "$read_perms" -gt 6 ]] || [[ "$write_perms" -gt 4 ]] || [[ "$execute_perms" -gt 4 ]]; then
            echo -en "[취약]\t" >> "$rf" 2>&1
            if [[ "$owner" != "root" ]]; then
                echo -en "NFS 접근제어 설정파일 소유자가 $owner으로 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
				echo "주요정보통신기반시설 가이드를 참고하시어 NFS접근제어 설정파일의 소유자를 root로 변경하여 주시기 바랍니다." >> "$rf" 2>&1
            fi
            if [[ "$read_perms" -gt 6 ]] || [[ "$write_perms" -gt 4 ]] || [[ "$execute_perms" -gt 4 ]]; then
                echo -en "NFS 접근제어 설정파일 권한이 $perms로 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
				echo "주요정보통신기반시설 가이드를 참고하시어 NFS접근제어 설정파일의 권한을 644이하로 변경하여 주시기 바랍니다." >> "$rf" 2>&1
            fi
        else
            echo -en "[양호]\t" >> "$rf" 2>&1
            echo "NFS 접근제어 설정파일 소유자가 root이고, 권한이 $perms로 설정되어 있는 상태입니다." >> "$rf" 2>&1
        fi
    else
        echo -en "[취약]\t" >> "$rf" 2>&1
        echo "NFS 설정파일이 존재하지 않습니다." >> "$rf" 2>&1
    fi
fi

