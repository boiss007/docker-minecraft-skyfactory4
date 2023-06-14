FROM alpine:latest

LABEL original_author="Tim Chaubet <tim@chaubet.be>"
LABEL maintainer="boiss007"

ARG SF4=https://edge.forgecdn.net/files/3565/687/SkyFactory-4_Server_4_2_4.zip

RUN addgroup --gid 1234 minecraft && \
 adduser --disabled-password --home=/data --uid 1234 -G minecraft --gecos "minecraft user" minecraft

RUN apk add unzip wget openjdk8

RUN mkdir /tmp/feed-the-beast && cd /tmp/feed-the-beast && \
 chmod -R 777 /tmp/feed-the-beast && \
 chown -R minecraft /tmp/feed-the-beast && \
 wget -c $SF4 -O SkyFactory_4_Server.zip && \
 unzip SkyFactory_4_Server.zip -d /tmp/feed-the-beast && \
 cd /tmp/feed-the-beast && sh -x Install.sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER minecraft

VOLUME /data
ADD server.properties /tmp/server.properties
WORKDIR /data

EXPOSE 25565

CMD ["sh start.sh"]

ENV MOTD "A Minecraft (SkyFactory 4.2.2) Server Powered by Docker"
ENV LEVEL world
ENV JVM_OPTS "-Xms2048m -Xmx2048m"