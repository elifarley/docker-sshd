FROM buildpack-deps:jessie
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=buildpack-deps:jessie

ENV \
NODE_VERSION=6.2.0 NPM_CONFIG_LOGLEVEL=info \
APT_PACKAGES="" \
TINI_VERSION='v0.5.0' TINI_SHA=066ad710107dc7ee05d3aa6e4974f01dc98f3888 \
GOSU_VERSION='1.5' GOSU_SHA=18cced029ed8f0bf80adaa6272bf1650ab68f7aa \
_USER=app \
LANG=en_US.UTF-8 TZ=${TZ:-Brazil/East} \
TERM=xterm-256color
ENV HOME=/$_USER JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"

EXPOSE 8080

ENTRYPOINT ["/bin/tini", "--", "/entry.sh"]
CMD ["/app/app.sh"]

WORKDIR $HOME

ADD https://github.com/elifarley/cross-installer/archive/master.tar.gz /tmp/cross-installer.tgz
ADD https://raw.githubusercontent.com/elifarley/cross-installer/master/install.sh /tmp/cross-installer.sh
RUN sh /tmp/cross-installer.sh /usr/local && \
  xinstall save-image-info && \
  xinstall add node $NODE_VERSION && \
  xinstall cleanup

RUN \
  xinstall add tini "$TINI_VERSION" "$TINI_SHA" && \
  xinstall add gosu "$GOSU_VERSION" "$GOSU_SHA"

RUN xinstall add-user "$_USER"

RUN xinstall add-base

COPY $_USER.sh $HOME/

ONBUILD COPY . "$HOME"/
ONBUILD RUN npm install
ONBUILD RUN chown -R "$_USER":nogroup "$HOME" && chmod -f +x "$HOME"/app.sh
