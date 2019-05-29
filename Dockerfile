# Ubuntu 16.04 LTS
# Oracle Java 1.8.172 64 bit
# Maven 3.5.4
# Jenkins 2.107.2
# git 1.9.1
# Nano 2.2.6-1ubuntu1

# extend the most recent long term support Ubuntu version
FROM ubuntu:16.04

MAINTAINER wzkworld@gmail.com

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

# update dpkg repositories AND install wget git nano
RUN apt-get update && apt-get install -y openjdk-8-jdk wget git nano && apt-get clean

# get maven 3.5.4
RUN wget -O /tmp/apache-maven-3.5.4.tar.gz http://mirror.bit.edu.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz

# Install maven
RUN tar xzf /tmp/apache-maven-3.5.4.tar.gz -C /opt/ && ln -s /opt/apache-maven-3.5.4 /opt/maven && ln -s /opt/maven/bin/mvn /usr/local/bin
ADD settings.xml /opt/apache-maven-3.5.4/conf/
ENV MAVEN_HOME /opt/maven

# copy jenkins war file to the container
ADD https://mirrors.tuna.tsinghua.edu.cn/jenkins/war-stable/latest/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins

# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080

CMD [""]
