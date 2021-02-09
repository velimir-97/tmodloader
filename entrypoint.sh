#!/bin/sh

pipe=/tmp/tmod.out
players=/tmp/tmod.players.out

function shutdown() {
  [ -n "$TMOD_SHUTDOWN_MSG" ] && inject "say $TMOD_SHUTDOWN_MSG"
  inject "exit"
  tmuxPid=$(pgrep tmux)
  tmodPid=$(pgrep --parent $tmuxPid Main)
  while [ -e /proc/$tmodPid ]; do
    sleep .5
  done
  rm $pipe
}

server="/terraria-server/tModLoaderServer.bin.x86_64"

if [ "$1" = "setup" ]; then
  $server
else
  trap shutdown SIGTERM SIGINT

  saveMsg='Autosave - $(date +"%Y-%m-%d %T")'
  idleMsg='Idle Check - $(date +"%Y-%m-%d %T")'

  if [ ! -z "$TMOD_AUTOSAVE_INTERVAL" ] && ! crontab -l | grep -q "Autosave"; then
    (crontab -l 2>/dev/null; echo "$TMOD_AUTOSAVE_INTERVAL echo \"$saveMsg\" > $pipe && inject save") | crontab -
  fi
  if [ ! -z "$TMOD_IDLE_CHECK_INTERVAL" ] && ! crontab -l | grep -q "Idle Check"; then
    (crontab -l 2>/dev/null; echo "$TMOD_IDLE_CHECK_INTERVAL echo \"$idleMsg\" > $pipe && handle-idle $players") | crontab -
  fi
  mkfifo $pipe
  tmux new-session -d "$server -config config.txt | tee $pipe $players" &
  sleep 60 && /usr/sbin/crond -d 8 &
  cat $pipe &

  wait ${!}
fi