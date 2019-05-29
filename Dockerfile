# Ubuntu 14.04 LTS
# Oracle Java 1.8.172 64 bit
# Maven 3.5.3
# Jenkins 2.107.2
# git 1.9.1
# Nano 2.2.6-1ubuntu1

# extend the most recent long term support Ubuntu version
FROM ubuntu:14.04

MAINTAINER wzkworld@gmail.com

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

# update dpkg repositories
RUN apt-get update 

# install wget
RUN apt-get install -y wget

# get maven 3.5.3
RUN wget -O /tmp/apache-maven-3.5.3.tar.gz http://mirrors.shu.edu.cn/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz

# verify checksum
#RUN echo "516923B3955B6035BA6B0A5B031FBD8B /tmp/apache-maven-3.5.3.tar.gz" | md5sum -c

# install maven
RUN tar xzf /tmp/apache-maven-3.5.3.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.5.3 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.5.3.tar.gz
ADD settings.xml /opt/apache-maven-3.5.3/conf/
ENV MAVEN_HOME /opt/maven

# install git
RUN apt-get install -y git

# install nano
RUN apt-get install -y nano

# remove download archive files
RUN apt-get clean

# set shell variables for java installation
ENV java_version 1.8.0_172
ENV filename jdk-8u172-linux-x64.tar.gz
ENV downloadlink http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/$filename

# download java, accepting the license agreement
RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/$filename $downloadlink 

# unpack java
RUN mkdir /opt/java-oracle && tar -zxf /tmp/$filename -C /opt/java-oracle/
ENV JAVA_HOME /opt/java-oracle/jdk$java_version
ENV PATH $JAVA_HOME/bin:$PATH

# configure symbolic links for the java and javac executables
RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

# copy jenkins war file to the container
ADD https://mirrors.tuna.tsinghua.edu.cn/jenkins/war-stable/latest/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins

# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080

CMD [""]
