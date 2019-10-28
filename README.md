# rgenius <img src="https://i.imgur.com/yTYa3fp.png" width="130px" align="right" />


Genius R scraper

This package includes a series of functions that give R users access to ["Genius"](https://genius.com/) data. These data are obtained by scraping their website.

## Installation

To install the most updated version from GitHub, type:

```r
library(devtools)
devtools::install_github("metalyrics/rgenius")
```

## Usage

First, you'll need docker on your pc.

Pull the browser's image:
```bash
$ sudo docker pull selenium/standalone-firefox
```

Run:
```bash
$ sudo docker run -d -p 4445:4444 --shm-size 2g selenium/standalone-firefox
```
Now you're ready to use the package.

### Example

```r
music_lyrics <- rmetacritic::get_music_lyrics("Lizzo", "Truth Hurts")
```

## Contributors
