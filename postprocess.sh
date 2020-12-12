#!/bin/bash

while getopts ":s:d:l:o:" opt; do
  case $opt in
    s) start="-ss $OPTARG"
    ;;
    d) duration="-to $OPTARG"
    ;;
    l) latency="-itsoffset $OPTARG"
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

ffmpeg -i $1 $latency -i $1 -c:a copy -c:v copy -map 0:v:0 -map 1:a:0 $start $duration $output
