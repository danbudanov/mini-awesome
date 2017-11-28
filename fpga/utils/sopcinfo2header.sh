#!/bin/bash

input_name=$1
file_name=${input_name%".sopcinfo"}
swinfo_file="$file_name.swinfo"
header_file="$file_name.h"

sopcinfo2swinfo.exe --input=$input_name --output=$swinfo_file
swinfo2header.exe --swinfo $swinfo_file --single $header_file --module "hps_0" 

# cleanup
rm $swinfo_file
