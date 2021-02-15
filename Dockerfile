FROM mono

LABEL maintainer="Velimir Stoleski <velimirr@gmail.com>"

ENV TMOD_VERSION=0.11.8
ENV TERRARIA_VERSION=1353
ENV TERRARIA_URL=http://terraria.org/server/terraria-server-1353.zip
RUN apt update &&\
    apt install -y unzip

WORKDIR /terraria-server

EXPOSE 7777

COPY setup.sh /terraria-server/setup.sh
RUN chmod +x /terraria-server/setup.sh

ENTRYPOINT ["/terraria-server/setup.sh"]
