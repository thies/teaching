# Video cutting with ffmpeg

Some command line tricks that I always forget

## Get height and width of video

```
ffprobe -v error -show_entries stream=width,height -of default=noprint_wrappers=1 video.mp4
```

## Create video from image




## Add sound


## concatenate two videos, both with audio

```
ffmpeg -i video1.mp4 -i video2.mp4 -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" video3.mp4
```


