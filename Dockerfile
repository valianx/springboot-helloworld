FROM gradle:jdk21-alpine AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build -x test

FROM openjdk:21-jdk-slim
EXPOSE 4000
RUN mkdir /app
WORKDIR /app
RUN adduser --no-create-home --disabled-password -u 1234 juser
USER juser

COPY --chown=juser:juser --from=build /home/gradle/src/build/libs/*SNAPSHOT.jar /app/spring-boot-application.jar
ENTRYPOINT ["java", "-jar" ,"/app/spring-boot-application.jar"]
