#!/bin/bash
EXPECTED_ARGS=1
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` {input file}"
  exit $E_BADARGS
fi

echo "Refining..."
convert $1 -colorspace RGB +sigmoidal-contrast 11.6933 -define filter:filter=Sinc -define filter:window=Jinc -define filter:lobes=3 -resize 400% -sigmoidal-contrast 11.6933 -colorspace sRGB refined.png
#convert $1 refined.png

echo "Monochroming..."
convert refined.png -threshold 60% monochrome.png

echo "Dilating..."
convert monochrome.png -morphology dilate:3 square dilated.png

echo "Eroding..."
convert dilated.png -morphology erode:20 square -clip-mask monochrome.png eroded.png

echo "Negating..."
convert eroded.png -negate refined.png -compose plus -composite result.png

#rm refined.png monochrome.png dilated.png eroded.png
