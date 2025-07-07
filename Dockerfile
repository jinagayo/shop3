#Dockerfile : 프로젝트 폴더에 생성
# 1단계 : 빌드 환경. Maven 빌드를 위한 설정
FROM openjdk:17-jdk-slim as builder
# 작업 폴더의 경로 app로 설정
WORKDIR /app
# 현재 shop3 전체를 app로 복사
COPY . .
# mvnw 파일에 실행권한 부여
RUN chmod +x mvnw
# mvnw : 빌드 수행 기능.
# clean package : 새로이 jar 파일 생성.
# -Dmaven.test.skip=true : 테스트 파일은 빌드에서 제외시킴
RUN ./mvnw clean package -Dmaven.test.skip=true

# 2단계 : 실제 런타임 환경
FROM openjdk:11-ea-17-jdk-slim
WORKDIR /app
# /shop3-0.0.1-SNAPSHOT.jar : 빌드로 생성된 jar 파일
# app.jar 빌드된 파일의 이름 설정
COPY --from=builder /app/target/shop3-0.0.1-SNAPSHOT.jar app.jar
# 포트 번호 정의. application.properties 에 정의된 포트와 동일해야함
EXPOSE 8080
# java -jar app.jar 명령문으로 컨테이너가 실행됨.
ENTRYPOINT [ "java", "-jar", "app.jar" ]