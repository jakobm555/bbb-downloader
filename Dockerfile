FROM debian:buster-slim

RUN apt-get update && apt-get install -y\
      bc ffmpeg python3 npm python3-pip\
    && rm -rf /var/lib/apt/lists/*

COPY bbb.py capture-full-replay.sh crop_video.sh download_bbb_data.py get_video_duration.sh package.json progress_bar.sh selenium-play-bbb-recording.js ./

RUN npm install

RUN pip3 install progressbar numpy

VOLUME [ "/videos" ]

USER bbb

ENTRYPOINT [ "capture-full-replay.sh" ]