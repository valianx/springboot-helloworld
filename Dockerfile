# Etapa 1: Construir la aplicación
FROM gradle:7.6-jdk17 AS build

# Instalar dependencias necesarias
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    dirmngr \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 \
    && apt-get update && apt-get install -y \
    libnss3 \
    libgconf-2-4 \
    libxi6 \
    libgdm1 \
    libxkbcommon-x11-0

# Configurar el directorio de trabajo
WORKDIR /app

# Copiar los archivos de Gradle y del proyecto
COPY --chown=gradle:gradle build.gradle settings.gradle /app/
COPY --chown=gradle:gradle src /app/src

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
