#!/bin/bash

#************************************************#
#                 flac2mp3.sh                    #
#           written by Nikita Korotkih           #
#                Jul 12, 2011                    #
#                                                #
#       Convert from flac to mp3                 #
#************************************************#


if [ -z "$1" ]
then
    echo "Usage: flac2mp3.sh <flac directory>";
    exit;
fi

if [ ! -d "$1" ]
then
    echo "$1 is not a directory";
    exit;
fi

flac_dir="$1";
mp3_dir="mp3_${flac_dir}";
mp3_dir=`echo "$mp3_dir" | sed -e "s/\///g" -e "s/ //g"`;

for i in "$flac_dir"/*; 
do 
    test ! -d "$mp3_dir"  && mkdir "$mp3_dir";
    is_flac=`echo $i | grep .flac | wc -l`;
    if [ $is_flac == 1 ]
    then 
    echo $i
        filename=$(basename "$i")
        filename=${filename%.*}
        ffmpeg -i "$i"  -ab 196k -ac 2 -ar 48000 "${mp3_dir}/${filename}.mp3"; 
    fi
done
