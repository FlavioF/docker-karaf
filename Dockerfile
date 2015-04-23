FROM pires/docker-jre

MAINTAINER Flávio Ferreira <flaviommferreira@gmail.com>

# expose Jolokia and Hazelcast (for Cellar)
EXPOSE 8778 5701 5005

ENV KARAF_VERSION 3.0.3
ENV KARAF_HOME /karaf
ENV DEPLOY_DIR $KARAF_HOME/deploy
ENV JOLOKIA_VERSION 1.2.3
ENV JAVA_HOME /opt/jre1.8.0_45

WORKDIR /tmp
# download, extract and install Karaf
RUN ( curl -Lskj http://archive.apache.org/dist/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz | \
    gunzip -c - | tar xf - ) && \
    mv apache-karaf-${KARAF_VERSION} ${KARAF_HOME} && \
    rm -rf /tmp/apache-karaf-${KARAF_VERSION}.tar.gz && \
    rm -rf ${KARAF_HOME}/deploy/*

# Download jolokia agent
RUN wget http://central.maven.org/maven2/org/jolokia/jolokia-jvm/${JOLOKIA_VERSION}/jolokia-jvm-${JOLOKIA_VERSION}-agent.jar -O ${KARAF_HOME}/jolokia-agent.jar

ENV KARAF_OPTS -javaagent:/$KARAF_HOME/jolokia-agent.jar=host=0.0.0.0,port=8778,authMode=jaas,realm=karaf,user=admin,password=admin,agentId=$HOSTNAME
ENV PATH $PATH:$KARAF_HOME/bin

ADD users.properties /karaf/etc/

CMD ["karaf"]