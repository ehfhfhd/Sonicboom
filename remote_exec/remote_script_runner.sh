#!/bin/bash

# Git 레포지토리 정보
REPO_URL="https://github.com/ehfhfhd/Sonicboom.git"
SCRIPT_PATH="CentOS6/CentOS6.sh"
SCRIPT_NAME="CentOS6.sh"
RESULT_FILE="result.json"
LOCAL_PATH="/home/ubuntu/tmp/Sonicboom" #취약점 진단 스크립트 위치
# 중앙서버에서는 root계정으로 접속

# 로컬에 레포지토리 클론
git clone "$REPO_URL" "$LOCAL_PATH"

mkdir -p "/srv/SNB_서버진단"

mkdir -p /home/ubuntu/make_xlsx
cp /home/ubuntu/tmp/Sonicboom/make_result.py /home/ubuntu/make_xlsx
cp /home/ubuntu/tmp/Sonicboom/tmp.xlsx /home/ubuntu/make_xlsx

# 원격 서버 목록파일에서 읽기
SERVER_LIST=()
while IFS= read -r line; do
	SERVER_LIST+=("$line")
done < "/home/ubuntu/servers_list.txt"

# 각 서버에 스크립트 실행 및 결과 파일 전송
for SERVER in "${SERVER_LIST[@]}"; do
    # 서버와 사용자명 분리
    USER=$(echo "$SERVER" | cut -d'@' -f1)
    HOST=$(echo "$SERVER" | cut -d'@' -f2)

    # 스크립트 전송
    scp -o StrictHostKeyChecking=no "$LOCAL_PATH/$SCRIPT_PATH" "$SERVER:/home/$USER/"

    # 스크립트 실행
    ssh -o StrictHostKeyChecking=no  "$SERVER" "sudo bash /home/$USER/$SCRIPT_NAME"

    #결과 파일명에 날짜 시간 추가보류
    NOW=$(date +%Y%m%d_%H%M%S)
    RESULT_FILENAME="${NOW}_result.json"


    # 결과 파일 전송
    # 결과 파일 가져오기
    scp -o StrictHostKeyChecking=no "$SERVER:/home/$USER/$RESULT_FILE" "/srv/SNB_서버진단/$RESULT_FILENAME"

done
# 엑셀 파일 추출
# python3 /home/ubuntu/make_xlsx/make_result.py
