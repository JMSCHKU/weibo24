#!/bin/bash
EXPECTED_ARGS=1
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` {input file}"
  exit $E_BADARGS
fi

convert $1 -colorspace RGB +sigmoidal-contrast 11.6933 \ 
-define filter:filter=Sinc -define filter:window=Jinc -define filter:lobes=3 \ 
-resize 400% -sigmoidal-contrast 11.6933 -colorspace sRGB refined.png
convert refined.png -threshold 60% monochrome.png
convert monochrome.png -morphology dilate:3 diamond dilated.png
convert dilated.png -morphology erode:20 diamond -clip-mask monochrome.png eroded.png
convert eroded.png -negate sample.jpg -compose plus -composite result.png

rm refined.png monochrome.png dilated.png eroded.png
