#!/bin/bash

FILE=$1
# echo $FILE
BASE=${FILE%.tex}
# echo $BASE
NAME=${BASE##*/}
# echo $NAME

latex $FILE >> convert.log
dvips -q ${NAME}.dvi  >> convert.log

#dvips -q* -E ${NAME}.dvi  >> convert.log
convert -density 200x200 ${NAME}.ps ${BASE}.png  >> convert.log 

rm ${NAME}.dvi ${NAME}.log ${NAME}.aux ${NAME}.ps convert.log &

printf "${BASE}.png"