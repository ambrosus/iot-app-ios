#!/bin/sh

# simple tool to generate app icons for iPhone/iPad (iOS 7+) from PDF
# brew dependencies: imagemagick, ghostscript

if [ $# -ne 1 ] ; then
    echo "\nUsage: Iconizer.sh icon-filen"
    exit
fi

if [ ! -e "$1" ] ; then
    echo "Can't find file $1!\n"
    exit
fi

# if [ ${1: -4} != ".pdf" ] ; then
#     echo "File $1 is not a pdf!\n"
#     exit
# fi

echo "Creating icons from $1"

for i in 20 29 40 58 60 76 80 87 120 152 167 180 ; do
    echo "Creating $ix$i px icon"
    convert $1 -scale $ix$i ./appicon_$i.png
done
