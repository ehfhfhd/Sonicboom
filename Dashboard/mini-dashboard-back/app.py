from flask import Flask, jsonify
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app, resources={r'*': {'origins': '*'}})
app.config['MAX_CONTENT_LENGTH'] = 1 * 1024 * 1024  # 파일 크기: 1MB

@app.route('/parse')
def parse_files():
    # EC2 인스턴스의 API URL 설정
    api_url = 'http://ec2-54-180-201-78.ap-northeast-2.compute.amazonaws.com:5001/api/diagnostics'
    
    # 원격 API로부터 데이터 요청
    response = requests.get(api_url)
    if response.status_code == 200:
        # API로부터 정상적으로 데이터를 받았을 경우, JSON 데이터를 파싱하여 반환
        data = response.json()  # JSON 응답을 파이썬 딕셔너리로 변환
        return jsonify(data)
    else:
        # API 요청에 실패했을 때 오류 메시지를 반환
        return jsonify({'error': 'Failed to fetch data from remote API'}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
