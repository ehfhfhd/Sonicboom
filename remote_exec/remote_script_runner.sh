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

mkdir -p /home/ubuntu/make_xlsx
cp /home/ubuntu/tmp/Sonicboom/make_python.py /home/ubuntu/make_xlsx
cp /home/ubuntu/tmp/Sonicboom/tmp.xlsx /home/ubuntu/make_xlsx

# 원격 서버 목록
SERVER_LIST=(
    "centos@3.38.165.230" # 사용자@ip주소
    # "centos@xxx.xxx.xxx.xxx" # 다른 서버 계속...
)

# 각 서버에 스크립트 실행 및 결과 파일 전송
for SERVER in "${SERVER_LIST[@]}"; do
    # 서버와 사용자명 분리
    USER=$(echo "$SERVER" | cut -d'@' -f1)
    HOST=$(echo "$SERVER" | cut -d'@' -f2)

    # 스크립트 전송
    scp -o StrictHostKeyChecking=no "$LOCAL_PATH/$SCRIPT_PATH" "$SERVER:/home/$USER/"

    # 스크립트 실행
    ssh -o StrictHostKeyChecking=no  "$SERVER" "sudo bash /home/$USER/$SCRIPT_NAME"

    # 결과 파일 전송
    # 결과 파일 가져오기
    scp -o StrictHostKeyChecking=no "$SERVER:/home/$USER/$RESULT_FILE" "/srv/${SERVER}.json"

done