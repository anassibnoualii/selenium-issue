ARG SELENIUM_TAG
FROM selenium/node-docker:$SELENIUM_TAG
RUN rm /opt/selenium/selenium-server.jar
ADD ["../selenium-server-4.16.0-SNAPSHOT.jar","/opt/selenium/selenium-server.jar"]