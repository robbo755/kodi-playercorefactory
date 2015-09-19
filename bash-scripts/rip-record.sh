#!/bin/bash

# ffmpeg record url from text file

if [[ $# < 1 ]]
	then
		printf "%b" "error not enough aruments passed to the script" '\n'
		exit 1 # exit with non zero		
elif [[ $# > 3 ]]
	 then
		printf "%b" "too many aruments passed to the script" '\n'
		exit 2 # exit with non zero
else

VIDEOURL=`cat "$1"`
TFLAG="$2"
DURATION="$3"

echo $VIDEOURL |
while read url
do
source video-regex.sh

case "$url" in
	"$VIDEOFILE")
	ffmpeg -hide_banner -i "$VIDEOFILE" \
	-c:v copy -c:a copy ${TFLAG} ${DURATION} \
	-loglevel error "$HOME/Desktop/video-$(date +"%m-%d-%y-%H-%M").mkv"
	;;
	"$M3U8")
	ffmpeg -hide_banner -i "$M3U8" \
	-c:v copy -bsf:a aac_adtstoasc ${TFLAG} ${DURATION} \
	-loglevel error "$HOME/Desktop/video-$(date +"%m-%d-%y-%H-%M").mkv"
	;;
	"$XFORWARD")
	ffmpeg -hide_banner -headers 'X-Forwarded-For: '"$XFORWARDIP"''$'\r\n' -i "$M3U8" \
	-c:v copy -bsf:a aac_adtstoasc ${TFLAG} ${DURATION} \
	-loglevel error "$HOME/Desktop/video-$(date +"%m-%d-%y-%H-%M").mkv"
	;;
	"$USEREF")
	ffmpeg -hide_banner -i  "$USERAGENT" -headers 'Referer: '"$REFERER"''$'\r\n' -i "$URL" \
	-c:v copy -c:a copy ${TFLAG} ${DURATION} \
	-loglevel error "$HOME/Desktop/video-$(date +"%H-%M-%m-%d-%y").mkv"
	;;
	"$M3U8USERAGENT")
	ffmpeg -hide_banner -loglevel error -user-agent "$M3U8UAG" -i "$M3U8UAGM3U8" \
	-c:v copy -bsf:a aac_adtstoasc ${TFLAG} ${DURATION} \
	-loglevel error "$HOME/Desktop/video-$(date +"%H-%M-%m-%d-%y").mkv"
	;;
	*)
	ffmpeg -hide_banner -i "$VIDEOURL" \
	-c:v copy -c:a copy ${TFLAG} ${DURATION} \
	-loglevel error "$HOME/Desktop/video-$(date +"%m-%d-%y-%H-%M").mkv"
	;;
esac
done
fi