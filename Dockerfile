FROM adoptopenjdk/openjdk11:alpine-jre

WORKDIR /opt/app

ARG JAR_FILE=target/spring_boot_tutorial-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar

ENTRYPOINT ["java","-Dserver.port=${PORT}","-jar","app.jar"]
