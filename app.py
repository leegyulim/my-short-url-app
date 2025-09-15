from flask import Flask, request, redirect

app = Flask(__name__)
# URL 데이터를 메모리에 간단히 저장 (나중에 DB로 변경 예정)
url_db = {}

@app.route('/')
def hello():
    return "CI/CD 자동 배포 성공"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)