source("./R/constants.R")
library(RSelenium)
library(magrittr)
library(stringr)
library(stringi)

get_music_lyrics <- function(song, artist) {
  remDr <- .open_remDr()
  scrap <- .scrape_song_lyrics(remDr, song, artist) %>%
    .create_lyrics_df()
  .close_remDr(remDr)
  return(scrap)
}

.scrape_song_lyrics <- function(remDr, song, artist) {
  remDr$navigate(paste0(WEBSITE_URL, .format_name(artist), "-", .format_name(song), "-lyrics" ))

  element <- remDr$findElement(using = 'class', value = 'lyrics')
  elemtxt <- element$getElementText()

  result <- strsplit(elemtxt[[1]],"\n\n")[[1]]
  return(result)
}

.create_lyrics_df <- function(scrape_result) {
  df <- data.frame(scrape_result) %>%
    dplyr::mutate(breaks = strsplit(as.character(result), "\n"))  %>%
    dplyr::mutate(verse_list = breaks) %>%
    tidyr::unnest(breaks) %>%
    dplyr::mutate(tag = dplyr::if_else(grepl("\\[",breaks), breaks, "")) %>%
    dplyr::select(-breaks) %>%
    unique()
  df[df==""]<-NA
  if (nrow(df %>% na.omit) != 0) {
    df <- df %>% na.omit()  %>%
      dplyr::select(verse_list, tag) %>%
      dplyr::mutate(verse_list = purrr::map(verse_list, tail, -1)) %>%
      dplyr::mutate(tag = str_replace_all(tag, "\\[", "")) %>%
      dplyr::mutate(tag = str_replace_all(tag, "\\]", ""))
  } else {
    df <- df %>%
      dplyr::select(verse_list, tag)
  }

  return(df)

}



