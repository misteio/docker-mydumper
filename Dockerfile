FROM alpine:edge AS build

MAINTAINER Jonathan Lubin <j@miste.io>

ENV PACKAGES="mysql-client" \
    LIB_PACKAGES="glib-dev mariadb-dev zlib-dev pcre-dev libressl-dev" \
    BUILD_PACKAGES="cmake build-base git" \
    BUILD_PATH="/opt/mydumper-src/"

RUN apk --no-cache add \
          $PACKAGES \
          $BUILD_PACKAGES \
          $LIB_PACKAGES \
    && \
    git clone https://github.com/maxbube/mydumper.git $BUILD_PATH

RUN cd $BUILD_PATH && cmake -DWITH_SSL=OFF . && make
RUN cd $BUILD_PATH && mv ./mydumper /usr/bin/. && mv ./myloader /usr/bin/.


# Create final stage containing myloader and mydumper without all libraries
FROM alpine:edge

# Create user non root and give access rights to execute
RUN addgroup -S maxbube && adduser -S maxbube -G maxbube
RUN apk --no-cache add mysql-client glib-dev mariadb-dev curl
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
	s3cmd
COPY --chown=maxbube --from=build /usr/bin/mydumper /usr/bin/mydumper
COPY --chown=maxbube --from=build /usr/bin/myloader /usr/bin/myloader

RUN mkdir /usr/mysql && chown -R maxbube /usr/mysql
USER maxbube

WORKDIR "/usr/mysql"

CMD ["/usr/sbin/crond", "-f", "-L", "7"]
