from flask import Flask, jsonify
from flask_cors import CORS
import os
import zipfile
import json

app = Flask(__name__)
CORS(app, resources={r'*': {'origins': '*'}})

# 파일을 저장할 서버의 디렉토리 경로 설정
app.config['UPLOAD_FOLDER'] = '/srv/scp_files'
app.config['MAX_CONTENT_LENGTH'] = 1 * 1024 * 1024  # 파일 크기 제한 설정 (1MB)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'zip'}

def parse_json_files(directory):
    results = []
    # 지정된 디렉토리 내의 모든 파일을 순회합니다.
    for filename in os.listdir(directory):
        if filename.endswith('.json'):
            filepath = os.path.join(directory, filename)
            with open(filepath, 'r') as json_file:
                results.append(json.load(json_file))
    return results

def process_file(filepath):
    # 업로드된 파일이 ZIP 파일인지 검사하고, ZIP 파일이면 압축 해제
    if zipfile.is_zipfile(filepath):
        with zipfile.ZipFile(filepath, 'r') as zip_ref:
            # 압축 해제한 파일들의 경로를 저장합니다.
            extract_path = os.path.join(app.config['UPLOAD_FOLDER'], 'extracted')
            # 압축 해제 디렉토리가 없으면 생성합니다.
            if not os.path.exists(extract_path):
                os.makedirs(extract_path)
            zip_ref.extractall(extract_path)
            print(f"Extracted to {extract_path}")

@app.route('/api/diagnostics', methods=['GET'])
def get_diagnostics():
    # '/srv/scp_files' 디렉토리에서 JSON 파일을 파싱
    diagnostics_data = parse_json_files(app.config['UPLOAD_FOLDER'])
    return jsonify(diagnostics_data)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)  # 외부 접근 허용, 포트 5001에서 실행

