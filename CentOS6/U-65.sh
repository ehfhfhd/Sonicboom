#!/bin/bash

# 결과 파일 경로
rf="result.txt"

# 항목 번호 기록
echo -en "U-65(중)\t3. 서비스관리\t3.29 AT 파일 소유자 및 권한 설정\t" >> "$rf" 2>&1
echo -en "at 접근제어 파일 소유자가 root이고, 권한이 640 이하인 경우\t" >> "$rf" 2>&1

# at.allow와 at.deny 파일 경로
at_files=("/etc/at.allow" "/etc/at.deny")

# 각 at 파일 검사
for file in "${at_files[@]}"; do
    if [ -f "$file" ]; then
        file_owner=$(stat -c "%U" "$file")
        file_perms=$(stat -c "%a" "$file")
        read_perm="${file_perms:0:1}"
        write_perm="${file_perms:1:1}"
        execute_perm="${file_perms:2:1}"

        if [ "$file_owner" != "root" ]; then
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo -en "$file의 소유자가 $file_owner로 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
			echo "주요정보통신기반시설 가이드를 참고하시어 $file의 소유자를 root로 설정하여 주시기 바랍니다." >> "$rf" 2>&1
        elif [[ "$read_perm" -le 6 ]] && [[ "$write_perm" -le 4 ]] && [[ "$execute_perm" -le 0 ]]; then
            # 이 경우는 양호하지만, at.allow와 at.deny가 존재하는 것만으로 양호 판단
            continue
        else
            echo -en "[취약]\t" >> "$rf" 2>&1
            echo -en "$file의 권한이 ${file_perms}으로 설정되어 있는 상태입니다.\t" >> "$rf" 2>&1
            echo "주요정보통신기반시설 가이드를 참고하시어 $file의 권한을 640 이하로 설정하여 주시기 바랍니다." >> "$rf" 2>&1
        fi
    fi
done

# at.allow와 at.deny 파일이 모두 존재하지 않는 경우
if [ ! -f "/etc/at.allow" ] && [ ! -f "/etc/at.deny" ]; then
    echo -en "[양호]\t" >> "$rf" 2>&1
    echo "root 만이 at 작업을 실행할 수 있도록 설정되어 있는 상태입니다." >> "$rf" 2>&1
fi

