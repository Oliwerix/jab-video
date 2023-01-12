#!/bin/bash
mkdir -p splits
cd splits
rm *
#split -b 3816 -d ../$1 $1
split -b $2 -d ../$1 $1
cd ..


find splits/* | parallel -j$((4*$(nproc))) --bar --joblog $1.log "./makeSingle.sh {} {}.png"
#for file in ./splits/*; do
#	echo $file
#	makeSingle $file $file.png &
#done
wait
echo Done with making images
echo Starting ffmpeg

#ffmpeg -y -f concat -safe 0 -i list.txt $1.mp4
ffmpeg -y -v 8 -pattern_type glob -i './splits/*.png' -preset faster -filter_complex "[0]pad=w=120+iw:h=120+ih:x=60:y=60:color=white" $1.mp4
awk -F '\t' '$7!=0 {printf "%s\t%s\n", $7, $9}' $1.log
echo Decoded with $(tail -n +2 $1.log | cut -f 7 | grep -c -v 0) errors
echo Output filename $1.mp4

