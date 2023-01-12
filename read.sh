mkdir -p splits
rm splits/*
rm $1.txt
#ffmpeg -i $1 -vf scale=800:-1 splits/$1%03d.png
ffmpeg -i $1 -vf scale=$2:-1 -hide_banner splits/$1%03d.png
find splits/*.png | parallel --joblog $1.log --bar 'jabcodeReader {} | head -c -1 - > {}.txt; exit ${PIPESTATUS[0]}'

#for file in ./splits/*.png; do
#	echo $file
#	jabcodeReader $file | head -c -1 - > $file.txt &
#done
wait
cat splits/*.txt > $1.txt
awk -F '\t' '$7!=0 {printf "%s\t%s\n", $7, $9}' $1.log
echo Decoded with $(tail -n +2 $1.log | cut -f 7 | grep -c -v 0) errors
echo Output filename $1.txt
