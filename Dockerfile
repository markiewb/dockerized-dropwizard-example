# Usage
# Create image with: docker build . --tag dropwizardexample
# Create and run container with JMX: docker run --rm -p 127.0.0.1:9090:8080 -p 127.0.0.1:10005:10005 -p 127.0.0.1:9091:7777 --name dropwizardcontainer dropwizardexample:latest
# 
# Open webapp in browser at http://localhost:9090/hello-world?name=Benno
# WITHIN the container: Access Jolokia via `curl -X GET http://127.0.0.1:7777/jolokia/`
# OUTSIDE of the container: Access Jolokia via `curl -X GET http://127.0.0.1:9091/jolokia/` 
# Connect with JMX-Client at localhost:10005
FROM openjdk:alpine

ENV URL=http://repo1.maven.org/maven2/org/jolokia/jolokia-jvm/1.3.7/jolokia-jvm-1.3.7-agent.jar
# Set the working directory to /app
WORKDIR /app

RUN apk add --no-cache curl && curl -O ${URL} && mv jolokia-jvm-1.3.7-agent.jar /app/jolokia-jvm-agent.jar && apk del curl

# Copy the current directory contents into the container at /app
ADD ./target/dropwizard.gettingstarted-1.0-SNAPSHOT.jar /app/app.jar
ADD hello-world.yml /app/hello-world.yml

# Make ports available to the world outside this container only as INFO
#HTTP
EXPOSE 8080  
#JMX
EXPOSE 10005 
# JMX over HTTP
# https://jolokia.org/agent/jvm.html
# http://repo1.maven.org/maven2/org/jolokia/jolokia-jvm/1.3.7/jolokia-jvm-1.3.7-agent.jar
EXPOSE 7777  


CMD [\
"java",\
"-javaagent:/app/jolokia-jvm-agent.jar=port=7777,host=0.0.0.0",\ 
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


