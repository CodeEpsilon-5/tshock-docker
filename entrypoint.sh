#! /bin/bash

cat << EOF > /tshock/serverconfig.txt
worldpath=/var/terraria/worlds/
world=/var/terraria/worlds/world.wld
autocreate=${AUTOCREATE:-1}
worldname=${WORLDNAME:-My World}
difficulty=${DIFFICULTY:-1}
maxplayers=${MAXPLAYERS:-8}
motd=${MOTD:-Please don’t cut the purple trees!}
language=${LANGUAGE:-en-US}
EOF

if [ ! -f "/tshock/ServerPlugins/TShockAPI.dll" ]; then
    echo Moving TShockAPI.dll;
    mv /tshock/TShockAPI.dll /tshock/ServerPlugins/TShockAPI.dll;
fi

if [ -z "$PASSWORD" ]; then
    echo $PASSWORD >> /tshock/serverconfig.txt;
fi

exec "$@"
