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


## Creating a seminar video clip

```
ffmpeg -r 1/2 -i titlepage.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p titlepage.mp4
ffmpeg -r 1/2 -i Q2.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p Q2.mp4
ffmpeg -r 1/2 -i Q3.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p Q3.mp4
ffmpeg -r 1/2 -i Q4.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p Q4.mp4
ffmpeg -r 1/2 -i Q5.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p Q5.mp4
ffmpeg -r 1/2 -i final.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p final.mp4

# rescale odd inputs
ffmpeg -i Q1.3gp -vf "scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2" Q1_rescaled.mp4
ffmpeg -i Q2.3gp -vf "scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2" Q2_rescaled.mp4
ffmpeg -i Q3.3gp -vf "scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2" Q3_rescaled.mp4
ffmpeg -i Q4.3gp -vf "scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2" Q4_rescaled.mp4
ffmpeg -i Q5.3gp -vf "scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2" Q5_rescaled.mp4

ffmpeg -i Q4_rescaled.mp4 -vf scale=960:540 -c:v libx264 -crf 0 -preset veryslow -c:a copy image.mp4
ffmpeg -i image.mp4 -i image.png -filter_complex "[1][0]scale2ref[i][v];[v][i]overlay" -c:a copy image_audio.mp4


# add audio to the text clips
ffmpeg -f lavfi -i aevalsrc=0 -i titlepage.mp4 -c:v copy -c:a aac -map 0 -map 1:v -shortest titlepage_audio.mp4
ffmpeg -f lavfi -i aevalsrc=0 -i Q2.mp4 -c:v copy -c:a aac -map 0 -map 1:v -shortest Q2_audio.mp4
ffmpeg -f lavfi -i aevalsrc=0 -i Q3.mp4 -c:v copy -c:a aac -map 0 -map 1:v -shortest Q3_audio.mp4
ffmpeg -f lavfi -i aevalsrc=0 -i Q4.mp4 -c:v copy -c:a aac -map 0 -map 1:v -shortest Q4_audio.mp4
ffmpeg -f lavfi -i aevalsrc=0 -i Q5.mp4 -c:v copy -c:a aac -map 0 -map 1:v -shortest Q5_audio.mp4
ffmpeg -f lavfi -i aevalsrc=0 -i final.mp4 -c:v copy -c:a aac -map 0 -map 1:v -shortest final_audio.mp4

# concatenate everything
ffmpeg -i titlepage_audio.mp4 -i Q1_rescaled.mp4 -i Q2_audio.mp4 -i Q2_rescaled.mp4 -i Q3_audio.mp4 -i Q3_rescaled.mp4 -i Q4_audio.mp4 -i image_audio.mp4 -i Q5_audio.mp4 -i Q5_rescaled.mp4 -i final_audio.mp4 \
-filter_complex "[0:v] [0:a] [1:v] [1:a] [2:v] [2:a] [3:v] [3:a] [4:v] [4:a] [5:v] [5:a] [6:v] [6:a] [7:v] [7:a] [8:v] [8:a] [9:v] [9:a] [10:v] [10:a]  concat=n=11:v=1:a=1 [v] [a]"  -map "[v]" -map "[a]" clip.mp4
```

### Good website on "filter_complex"
https://dev.to/dak425/concatenate-videos-together-using-ffmpeg-2gg1
