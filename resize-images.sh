#!/bin/bash

#
# works with Nautilus 
#
# TODO:
#  - make script universe
#  - make it runnable from a console

NEW_RES=1024

IFS=$'\n'
n=0
for _ in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do n=$(($n + 1)); done
i=0
for name in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
  i=$(($i + 1))
  if [ -f "$name" ]; then
    bn=`basename "$name"`
    echo "# $bn"
    new_name=`echo "$name" | sed 's/\(.*\)\(\....\)/\1-'$NEW_RES'\2/'`
    [ "$new_name" != "$name" ] && convert "$name" -resize $NEW_RES "$new_name"
    rm $name
  fi
  echo $(($i * 100 / $n))
done | zenity --progress --auto-close --auto-kill
unset IFS
