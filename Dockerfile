
FROM tomcat:10.1-jdk21-temurin

ENV PORT=10000

RUN rm -rf /usr/local/tomcat/webapps/*

COPY src/main/webapp/ /usr/local/tomcat/webapps/ROOT/
COPY src/main/java/ /tmp/java/

RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    && javac -encoding UTF-8 \
    -cp "/usr/local/tomcat/lib/*:/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/*" \
    -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    $(find /tmp/java -name "*.java")

EXPOSE 10000

CMD ["bash", "-c", "sed -i 's/port=\"8080\"/port=\"'\"${PORT:-10000}\"'\"/' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
