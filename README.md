# tika-v1

Contains a deployment of a custom tika 1.x server as a docker image. Please refer to https://github.com/puthurr/tika for more details.

Based on Apache Tika version : 1.27

# Building images

## Build the docker image using Docker runtime (example)

```
docker build -f Dockerfile -t tika/serverX .
```

## Build the docker image using Azure ACR

```
ACR_NAME=<registry-name>
az acr build --image tika/serverX --registry $ACR_NAME --file Dockerfile .
```

# Updating to a new Server JRE 

## Download the Server JRE 8 from Oracle 

https://www.oracle.com/java/technologies/downloads/#java8

We use the Linux x64 Server JRE distribution aka server-jre-8u311-linux-x64.tar.gz

## Note the checksum of your download 

https://www.oracle.com/a/tech/docs/8u311checksum.html

```
server-jre-8u311-linux-x64.tar.gz	
sha256: 4132d53f500fea109386a5734dc156468558d792082cfbd39f0a097e6f55e710
md5: 01c29e7adf7eae704a3d04f0d353f624
```

## Update the docker file with the new jre version and sha256 

```
ENV JAVA_VERSION=1.8.0_311 \
	JAVA_PKG=server-jre-8u311-linux-x64.tar.gz \
	JAVA_SHA256=4132d53f500fea109386a5734dc156468558d792082cfbd39f0a097e6f55e710 \
	JAVA_HOME=/usr/java/jdk-8
```

## Rebuild your image
