FROM java:openjdk-8-jdk-alpine
MAINTAINER Elifarley Cruz <elifarley@gmail.com>

ENV TZ ${TZ:-Brazil/East}
ENV JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"

RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk --update add --no-cache tzdata ttf-dejavu curl openssh rsync shadow bash git && \
  echo "TZ set to '$TZ'" && echo $TZ > /etc/TZ && cp -a /usr/share/zoneinfo/"$TZ" /etc/localtime && apk del tzdata && \
  rm -rf /var/cache/apk/*

RUN sed -e '/Port/d;/UsePrivilegeSeparation/d;/PermitRootLogin/d;/UsePAM/d;/PasswordAuthentication/d;/ChallengeResponseAuthentication/d;/Banner/d;/PrintMotd/d;/PrintLastLog/d' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && \
printf "\nPort 2200\nUsePrivilegeSeparation no\nPermitRootLogin no\nPasswordAuthentication no\nChallengeResponseAuthentication no\nPrintMotd no\n#---\n" > /etc/ssh/sshd_config && cat /etc/ssh/sshd_config.tmp >> /etc/ssh/sshd_config && rm /etc/ssh/sshd_config.tmp && \
  cp -a /etc/ssh /etc/ssh.cache

ENV TINI_SHA 066ad710107dc7ee05d3aa6e4974f01dc98f3888
ENV GOSU_SHA 18cced029ed8f0bf80adaa6272bf1650ab68f7aa

# Use tini as subreaper in Docker container to adopt zombie processes 
# Grab gosu for easy step-down from root.
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v0.5.0/tini-static -o /usr/local/bin/tini && chmod +x /usr/local/bin/tini && \
  echo "$TINI_SHA  /usr/local/bin/tini" | sha1sum -wc - && \
  curl -fsSL https://github.com/tianon/gosu/releases/download/1.5/gosu-amd64 -o /usr/local/bin/gosu && chmod 755 /usr/local/bin/gosu && \
  echo "$GOSU_SHA  /usr/local/bin/gosu" | sha1sum -wc -

# Install Maven
ENV MAVEN_VERSION 3.3.9
ENV MAVEN_SHA 5b4c117854921b527ab6190615f9435da730ba05
RUN curl -fsSL http://www-us.apache.org/dist/maven/maven-3/"$MAVEN_VERSION"/binaries/apache-maven-"$MAVEN_VERSION"-bin.tar.gz -o /tmp/maven.tgz && \
  echo "$MAVEN_SHA  /tmp/maven.tgz" | sha1sum -wc - && \
  tar -xzf /tmp/maven.tgz -C /usr/local && rm /tmp/maven.tgz && \
  ln -s apache-maven-"$MAVEN_VERSION" /usr/local/maven-3 && ln -s ../maven-3/bin/mvn ../maven-3/bin/mvnDebug ../maven-3/bin/mvnyjp /usr/local/bin

ENV _USER app
ENV HOME /$_USER
RUN adduser -D -h "$HOME" -s /bin/bash $_USER && \
  mkdir -p $HOME/.ssh && chmod go-w $HOME && chmod 700 $HOME/.ssh && chown $_USER:$_USER -R $HOME && \
  echo 'auth requisite  pam_deny.so' > /etc/pam.d/su

WORKDIR $HOME

ENV LANG en_US.UTF-8

EXPOSE 2200

ADD https://raw.githubusercontent.com/elifarley/docker-dev-env/master/entry.sh /entry.sh
RUN chmod +x /entry.sh
ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]