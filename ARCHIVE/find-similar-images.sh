#!/bin/bash
# Description: Simple bash script to identify similar images
# in a directory. The script uses the great imagemagick
# tool suite to identify image formats, rescale images to same
# sizes before comparing and finally performs comparison
# and calculates an RMSE pixel error value for each image pair.
#
# Charalamapos Arapidis
# arapidhs@gmail.com
# 7/12/2012

######################################################
# USAGE FUNCTION
# Usage imgcompare /path
# display usage function
function usage () {
   cat <<EOF

Usage:
$scriptname [directory]
example:
imgcompare.sh ~/images

EOF
   exit 0
}
######################################################


######################################################
# VARIABLES DECLARATION
scriptname=$0
directory= # the directory that contains image files to compare
threshold=10 # option -t, RMSE values below this percentage threshold are hits
source=  # source file
target=  # target file
images=  # array of image files
result=  # store the results in a three column format RMSE|source|target
OIFS=$IFS
######################################################


######################################################
# FILTER IMAGE FILES
# get all files in the directory
# and filter out files that are not images
# store images in the $images array
# If user did not supply a  directory
# start searching from the working directory pwd
if [ -z "$1" ]; then
 directory=$pwd
else
 directory=$1
fi
files=(`find $directory -type f`)
length=${#files[@]}
count=0
for (( i=0 ; $i < $length; i=$i+1 )); do
 file=${files[$i]}
  identify -quiet -ping $file >/dev/null 2>/dev/null;
 if [ $? -eq 0 ]; then
  images[$count]=$file
  let count++
 fi
done
######################################################


######################################################
# COMPARE IMAGES
# compare all pair of images in the directory
# and store the results of each hit / comparison
# in the results variable in the following format:
# RMSE|source|target
length=${#images[@]}
count=0
for (( i=0 ; $i < $length-1; i=$i+1 )); do
 # set source to next image
 source=${images[$i]}
 start=$i+1

 # in a nested loop compare the source image starting from its
 # index to the length of tha array
 for (( j=$start ; $j < $length; j=$j+1 )); do
  # get target image
  target=${images[$j]}

  # find the dimensions of the image in format height,width
  srcDim=`identify -format "%h,%w" $source`
  trgDim=`identify -format "%h,%w" $target`

  # compare the dimensions of the images
  # if are of equal size proceed with the comparison
  if [ $srcDim == $trgDim ]; then
   out=`compare -metric RMSE $source $target null: 2>&1;`
   if [ $? -eq 0 ]; then
    result=$result"\n"$out"\t"$source"\t"$target
   fi
  fi
 done
done
######################################################

echo -e $result | sort -n


