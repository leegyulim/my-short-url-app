# 1. 베이스 이미지 선택 (가볍고 효율적인 slim 버전 사용)
FROM python:3.10-slim

# 2. 작업 디렉토리 설정 (컨테이너 내부의 코드 저장 위치)
WORKDIR /app

# 3. 의존성 파일 먼저 복사 (소스코드 변경 시 빌드 캐시를 활용하기 위함)
COPY requirements.txt .

# 4. 의존성 설치 (캐시 사용 안 함 옵션으로 이미지 용량 최적화)
RUN pip install --no-cache-dir -r requirements.txt

# 5. 소스 코드 전체 복사
COPY . .

# 6. 컨테이너 실행 시 실행될 명령어
# --host=0.0.0.0 옵션은 컨테이너 외부에서 접속을 허용하기 위해 필수!
CMD ["flask", "run", "--host=0.0.0.0"]
