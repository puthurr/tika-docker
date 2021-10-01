# Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
#
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

FROM oraclelinux:7-slim

LABEL maintainer="Aurelio Garcia-Ribeyro <aurelio.garciaribeyro@oracle.com>"

RUN set -eux; \
	yum install -y \
		gzip \
		tar \
	; \
	rm -rf /var/cache/yum
	
RUN set -eux; \
	yum update openssl \
	; \
	rm -rf /var/cache/yum

# Default to UTF-8 file.encoding
ENV LANG en_US.UTF-8

# Download the JDK from
#
#  https://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html
#	
# and place it on the same directory as the Dockerfile
#
ENV TIKA_VERSION 1.27
ENV TIKA_SERVER_PKG=tika-server-$TIKA_VERSION.jar
ENV TIKA_HOME=/usr/local

ENV JAVA_VERSION=1.8.0_281 \
	JAVA_PKG=server-jre-8u281-linux-x64.tar.gz \
	JAVA_SHA256=e452da44875d72b237860214f943af94eb3cbb76140a8df9b0f23cb65cb06cef \
	JAVA_HOME=/usr/java/jdk-8
ENV	PATH $JAVA_HOME/bin:$PATH

##
COPY $JAVA_PKG /tmp/jdk.tgz
COPY $TIKA_SERVER_PKG $TIKA_HOME

RUN set -eux; \
	\
	echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c -; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
	rm /tmp/jdk.tgz; \
	\
	ln -sfT "$JAVA_HOME" /usr/java/default; \
	ln -sfT "$JAVA_HOME" /usr/java/latest; \
	for bin in "$JAVA_HOME/bin/"*; do \
		base="$(basename "$bin")"; \
		[ ! -e "/usr/bin/$base" ]; \
		alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
	done; \
# -Xshare:dump will create a CDS archive to improve startup in subsequent runs	
	java -Xshare:dump; \
	java -version; \
	javac -version

EXPOSE 9998
ENTRYPOINT java -XX:MaxRAMPercentage=90.0 -jar ${TIKA_HOME}/tika-server-${TIKA_VERSION}.jar -h 0.0.0.0
