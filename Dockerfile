FROM mono

ARG TSHOCK_VERSION

EXPOSE 7777

RUN apt-get update && apt-get install -y \
    wget \
    jq \
    unzip && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tshock /var/terraria/worlds /var/terraria/tshock

WORKDIR /tshock

RUN useradd -m tshock

RUN curl "https://api.github.com/repos/Pryaxis/TShock/releases/tags/v$TSHOCK_VERSION" | jq '.assets[0].browser_download_url' | xargs wget \
    && unzip *.zip \
    && mv TShock*/* /tshock \
    && mv ServerPlugins/TShockAPI.dll /tshock \
    && rm *.zip \
    && rm -rf TShock*_Terraria*

ADD --chown=tshock:tshock ./entrypoint.sh /tshock/entrypoint.sh

RUN chown -R tshock:tshock /tshock /var/terraria && chmod -R 777 /var/terraria /tshock

USER tshock

ENTRYPOINT [ "/bin/sh", "/tshock/entrypoint.sh" ]

CMD ["mono", "/tshock/TerrariaServer.exe", "-config", "/tshock/serverconfig.txt", "-configpath", "/var/terraria/tshock"]
