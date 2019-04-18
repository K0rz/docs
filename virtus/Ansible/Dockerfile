FROM tomcat
MAINTAINER alex

RUN apt-get update && apt-get -y upgrade
WORKDIR /usr/local/tomcat

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

EXPOSE 1234

RUN mkdir /usr/local/tomcat/webapps/target
VOLUME /var/lib/jenkins/workspace/pipeline1/target:/usr/local/tomcat/webapps/target

CMD ["java", "-jar", "/usr/local/tomcat/webapps/target/simple-app-0.1-SNAPSHOT.jar"]