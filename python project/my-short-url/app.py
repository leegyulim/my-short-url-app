from flask import Flask, request, redirect

app = Flask(__name__)
# URL 데이터를 메모리에 간단히 저장 (나중에 DB로 변경 예정)
url_db = {}

@app.route('/')
def hello():
    return "나만의 단축 URL 서비스에 오신 것을 환영합니다!!!"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)