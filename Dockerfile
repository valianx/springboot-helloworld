# Etapa 1: Construir la aplicación
FROM gradle:7.6-jdk17 AS build

# Instalar dependencias necesarias
USER root
RUN apt-get update && apt-get install -y libnss3-dev libgconf-2-4

# Configurar el directorio de trabajo
WORKDIR /app

# Copiar los archivos de Gradle y del proyecto
COPY build.gradle settings.gradle /app/
COPY src /app/src

# Establecer permisos adecuados para los archivos de Gradle
RUN chown -R gradle:gradle /app

# Configurar directorio temporal para Gradle
ENV GRADLE_USER_HOME=/app/.gradle

# Ejecutar el build como el usuario gradle
USER gradle
RUN gradle build --no-daemon

# Etapa 2: Crear la imagen para ejecutar la aplicación
FROM openjdk:21-jdk-slim

# Configurar el directorio de trabajo
WORKDIR /app

# Copiar el JAR construido desde la etapa 1
COPY --from=build /app/build/libs/*.jar app.jar

# Exponer el puerto de la aplicación
EXPOSE 4000

# Ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
