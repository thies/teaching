# teaching
Code snippets for teaching


## Create PDFs from reveal.js presentation
```
# run a small webserver
python3 -m http.server 9900
# pull the PDF via Docker
ip=$(hostname  -I | cut -f1 -d' ')
sudo docker run --rm -t -v `pwd`:/slides astefanutti/decktape http://$ip:9900 slides.pdf -s 1124x768
# make PDFs a bit smaller
ps2pdf large.pdf small.pdf
```

## manual classification of images
```
feh -Z --recursive --action1 "mv '%f' ./like/" --action2 "mv '%f' ./dislike/" --action3 "mv '%f' ./delete/"  house/*.jpg &
```
