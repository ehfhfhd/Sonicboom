import json
import os

# JSON 파일을 파싱하는 함수
def parse_json(filepath):
    with open(filepath, 'r') as file:
        return json.load(file)

# 지정된 디렉토리 내의 모든 JSON 파일을 파싱하는 함수
def parse_all_json_files(directory):
    data = []
    for filename in os.listdir(directory):
        if filename.endswith('.json'):
            filepath = os.path.join(directory, filename)
            data.append(parse_json(filepath))
    return data
