#!/bin/bash

while getopts ":s:d:l:o:" opt; do
  case $opt in
    s) start="$OPTARG"
    ;;
    d) duration="$OPTARG"
    ;;
    l) latency="$OPTARG"
    ;;
    o) output="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2 && exit;
    ;;
  esac
done

# remove the options from the command line
shift $(($OPTIND - 1))
if [ $# -lt 1 ]; then
    #usage
    exit 2
fi

echo $start
echo $duration
echo $1

ffmpeg -i $1 -itsoffset $latency -i $1 -c:a copy -c:v copy -map 0:v:0 -map 1:a:0 -ss $start -to $duration $output
