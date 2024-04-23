from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import json
import os

app = Flask(__name__)
CORS(app, resources={r'*': {'origins': '*'}})
app.config['MAX_CONTENT_LENGTH'] = 1 * 1024 * 1024  # 파일 크기: 1MB

@app.route('/api/upload', methods=['POST'])
def upload_file():
    uploaded_file = request.files.get('file')
    if uploaded_file is None or uploaded_file.filename == '':
        return render_template('error_page.html')
    if uploaded_file.mimetype != 'application/zip':
        return render_template('error_page.html')
    # 파일 저장 로직
    return jsonify({"message": "File uploaded successfully"})

@app.route('/')
def index():
    return render_template('upload.html')

@app.route('/parse')
def parse_files():
    data = parse_all_json_files(r'\\wsl$\Ubuntu\srv\scp_files')
    return jsonify(data)

def parse_all_json_files(directory):
    results = []
    for filename in os.listdir(directory):
        if filename.endswith('.json'):
            filepath = os.path.join(directory, filename)
            with open(filepath, 'r', encoding='utf-8') as json_file:
                results.append(json.load(json_file))
    return results

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
