# teaching
Code snippets for teaching


## Create PDFs from reveal.js presentation
```
python3 -m http.server 9900
sudo docker run --rm -t -v `pwd`:/slides astefanutti/decktape https://lindenthal.eu/talks/talk-risk-return-portfolios/ slides.pdf -s 1124x768
```
