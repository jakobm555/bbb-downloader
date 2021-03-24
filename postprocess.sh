#!/bin/bash

useage()
{
cat << EOF
usage: $0 [options] input_file output_file

OPTIONS:
   -s offset         Start with offset
   -d duration       Cut after time          
   -l latency        offset betqween video and audio in seconds
   -o output_file    Output file
   -p true           Presentation only
   -c true           Copy (faster conversion but keyframe problem at beginning)
EOF
}

while getopts ":s:d:l:o:p:c:" opt; do
  case $opt in
    s) start="-ss $OPTARG"
    ;;
    d) duration="-to $OPTARG"
    ;;
    l) latency="-itsoffset $OPTARG"
    ;;
    o) output="$OPTARG"
    ;;
    p) presentation_only="$OPTARG"
    ;;
    c) copy="$OPTARG"
    ;;    
    \?) echo "Invalid option -$OPTARG" >&2 && useage && exit;
    ;;
  esac
done

# remove these options from the command line
shift "$(($OPTIND - 1))"
if [ $# -lt 1 ]; then
    echo "Exit. Something's wrong with parameters"
    useage
    exit 2
fi

# use copy for faster conversion
if [ "$copy" = "true" ]; then
    codec='-c:a copy -c:v copy'
else
    codec='-c:a aac -c:v libx264'
    afilter='-filter:a aresample=async=1'
fi



#only the main presentation screen
if [ "$presentation_only" = "true" ]; then
    if [ "$copy" = "true" ]; then
        echo "Attention! no copy mode with cropping possible. Switching -c to false." && copy=false
    fi
    vfilter="-filter:v crop=1280:880:0:0"
fi

    
echo "executing: ffmpeg -i $1 $latency -i $1 $codec $afilter $vfilter  -map 0:v:0 -map 1:a:0 $start $duration $output"

ffmpeg -i $1 $latency -i $1 $codec $afilter $vfilter -map 0:v:0 -map 1:a:0 $start $duration $output
