# Etapa 1: Construir la aplicación
FROM gradle:7.6-jdk17 AS build

# Configurar el directorio de trabajo
WORKDIR /app

# Copiar los archivos de Gradle y del proyecto
COPY build.gradle settings.gradle /app/
COPY src /app/src

# Ejecutar el build
RUN gradle build --no-daemon

# Etapa 2: Crear la imagen para ejecutar la aplicación
FROM openjdk:21-jdk-slim

# Configurar el directorio de trabajo
WORKDIR /app

# Copiar el JAR construido desde la etapa 1
COPY --from=build /app/build/libs/*.jar app.jar

# Exponer el puerto de la aplicación
EXPOSE 8080

# Ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
