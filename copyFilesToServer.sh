#!/bin/sh

# inputs:
# $1 == 0: copy files to server
# $1 == 1: copy files from server
# $2: population folder name

local_dir=/media/yn259/data/research
server_dir=/home/yn259/apps/grapegs
url=cbsurobbins.biohpc.cornell.edu

if [ "$1" -eq "0" ]
then
   	echo "Copying files to server"
	scp -r $local_dir/$2/analysis/grm* $local_dir/$2/analysis/drm* $url:$server_dir/$2/
else
   	echo "Copying files from server"
	scp -r $url:$server_dir/results/$2/* $local_dir/$2/
fi

# copy necessary files into results folder
# find . \( -name "*.asr" -o -name "*.pvs" -o -name "*.sln" \) -exec cp --parents \{\} ../results/HC/ \;