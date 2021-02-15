#!/bin/bash
curl -SLO $TERRARIA_URL
unzip terraria-server-*.zip
rm terraria-server-*.zip
cp --verbose -a "${TERRARIA_VERSION}/Linux/." .
rm -rf "${TERRARIA_VERSION}"
rm TerrariaServer.bin.x86 TerrariaServer.exe

curl -SL "https://github.com/tModLoader/tModLoader/releases/download/v$TMOD_VERSION/tModLoader.Linux.v$TMOD_VERSION.tar.gz" | tar -xvz
rm -r lib tModLoader.bin.x86 tModLoaderServer.bin.x86
chmod u+x tModLoaderServer*

/terraria/tModLoaderServer