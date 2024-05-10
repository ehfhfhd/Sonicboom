## 프로젝트 소개
CCE Linux취약점 항목 분석 및 자동화 진단 도구 제작
- 주요통신기반시설 가이드를 기반으로 취약점 진단 스크립트 작성
- 진단 결과 리포팅 툴 개발(EXCEL, WEB)

## 팀원 소개
<div align="center">

| **서준호** | **김지원** | **유정현** | **정유진** |
| :------: |  :------: | :------: | :------: |
| [<img src="https://avatars.githubusercontent.com/u/101813425?v=4" height=150 width=150> <br/> @DDunos](https://github.com/DDunos) | [<img src="https://avatars.githubusercontent.com/u/86232285?v=4" height=150 width=150> <br/> @ehfhfhd](https://github.com/ehfhfhd) | [<img src="https://avatars.githubusercontent.com/u/63927229?v=4" height=150 width=150> <br/> @wjdgus06](https://github.com/wjdgus06) | [<img src="https://avatars.githubusercontent.com/u/165754811?v=4" height=150 width=150> <br/> @kyj36](https://github.com/kyj36) |

</div>

## 개발 환경
<img src="https://img.shields.io/badge/Python-3776AB?style=flat&logo=Python&logoColor=white"/> <img src="https://img.shields.io/badge/javascript-F7DF1E?style=flat&logo=javascript&logoColor=black"/> <img src="https://img.shields.io/badge/bash-4EAA25?style=flat&logo=gnubash&logoColor=black&title_color=black"/> <br>
<img src="https://img.shields.io/badge/jenkins-D24939?style=flat&logo=jenkins&logoColor=white"/> <img src="https://img.shields.io/badge/Flask-000000?style=flat&logo=Flask&logoColor=white"/> <img src="https://img.shields.io/badge/node.js-5FA04E?style=flat&logo=nodedotjs&logoColor=white"/> <img src="https://img.shields.io/badge/React-61DAFB?style=flat&logo=React&logoColor=black"/> <img src="https://img.shields.io/badge/Linux-FCC624?style=flat&logo=Linux&logoColor=black"/> <img src="https://img.shields.io/badge/Amazon AWS-232F3E?style=flat-square&logo=amazonaws&logoColor=white"/>



## 🏗️시스템 구성
<img src="https://github.com/ehfhfhd/Sonicboom/assets/63927229/616bc47e-88e6-4a5b-a80f-40b28cb552e5" width="400"/>
<img src="https://github.com/ehfhfhd/Sonicboom/assets/63927229/e8d0bcc1-756a-439e-8cc7-44d27178d2f7" width="350"/>


## 📢EXCEL파일 추출 방법
1. 필요 파이썬 툴을 다음 명령어로 설치한다.<br>
    ```
    pip install pandas
    pip install openpyxl
    pip install xlsxwriter
    ```
2. remote_exec/servers_list.txt 파일에 진단하고자 하는 서버를 저장한다.
   [username]@[ip]
3. 중앙서버의 키를 취약점 진단을 수행할 원격서버에 심어준다.
4. remote_exec/remote_script_runner.sh파일을 중앙서버에 저장하여 실행한다.<br>
   ```bash remote_script_runner.sh```
5. make_xlsx 디렉토리 내부에 생성된 취약점 진단 결과 excel파일을 확인할 수 있다.
   
## ⭐결과물
### 1. Excel
   <img src="https://github.com/ehfhfhd/Sonicboom/assets/63927229/b60305b6-e018-4f4c-bd82-485501a9a4c8" width="700"/>
   <img src="https://github.com/ehfhfhd/Sonicboom/assets/63927229/b590e61f-2c97-4e8b-a94e-2cc5a7815d94" width="700"/><br>
   
[📊샘플파일.xlsx](https://github.com/ehfhfhd/Sonicboom/files/15271044/result_20240502.xlsx)


### 2. 대시보드
  <img src="https://github.com/ehfhfhd/Sonicboom/assets/63927229/93559976-1505-4458-91c5-b8069e92f18b" width="700"/>
  <img src="https://github.com/ehfhfhd/Sonicboom/assets/63927229/40556885-bccf-4174-8d84-9f6d25d8ca06" width="700"/>

