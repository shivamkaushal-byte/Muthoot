FROM ubuntu:latest

# Update packages and install Java
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk

RUN apt-get install -y maven

# Set the working directory in the container
WORKDIR /app

# Install Git
RUN apt-get install -y git

# Clone the Spring Boot application code from GitHub
RUN git clone https://github.com/soumyakbhattacharyya/devops-assessment.git

# Set the working directory to the cloned repository
WORKDIR /app/devops-assessment/my-app

# Build the Spring Boot application
RUN mvn clean package

# Set the entry point to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "target/my-app-0.0.1-SNAPSHOT.jar"]
