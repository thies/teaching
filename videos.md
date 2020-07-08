# Video cutting with ffmpeg

Some command line tricks that I always forget

## Get height and width of video

```
ffprobe -v error -show_entries stream=width,height -of default=noprint_wrappers=1 Jeff.mp4
```
