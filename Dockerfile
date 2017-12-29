# Usage
# Create image with: docker build . --tag dropwizardexample
# Create and run container with JMX: docker run --rm -p 127.0.0.1:9090:8080 -p 127.0.0.1:10005:10005 --name dropwizardcontainer dropwizardexample:latest
# 
# Open browser at http://localhost:9000/hello-world?name=Benno
# Connect with JMX-Client at localhost:10005
FROM openjdk:alpine

# Copy the current directory contents into the container at /app
ADD ./target/dropwizard.gettingstarted-1.0-SNAPSHOT.jar /app/app.jar
ADD hello-world.yml /app/hello-world.yml
# Set the working directory to /app
WORKDIR /app
#RUN chmod +x catalina.sh

# Make port 80 available to the world outside this container
EXPOSE 8080

CMD [\
"java",\ 
"-Dcom.sun.management.jmxremote",\
"-Dcom.sun.management.jmxremote.local.only=false",\
"-Dcom.sun.management.jmxremote.authenticate=false",\ 
"-Dcom.sun.management.jmxremote.port=10005", \
"-Dcom.sun.management.jmxremote.rmi.port=10005",\ 
"-Djava.rmi.server.hostname=127.0.0.1", \
"-Dcom.sun.management.jmxremote.ssl=false",\
"-jar", \
"./app.jar",\ 
"server", \
"hello-world.yml"]

