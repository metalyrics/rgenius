source("./R/constants.R")
source("./R/utils.R")
source("./R/selenium_wrapper.R")


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
    mutate(breaks = strsplit(as.character(result), "\n"))  %>%
    mutate(verse_list = breaks) %>%
    unnest(breaks) %>%
    mutate(tag = if_else(grepl("\\[",breaks), breaks, "")) %>%
    select(-breaks) %>%
    unique()
  df[df==""]<-NA
  if (nrow(df %>% na.omit) != 0) {
    df <- df %>% na.omit()  %>%
      select(verse_list, tag) %>%
      mutate(verse_list = map(verse_list, tail, -1)) %>%
      mutate(tag = str_replace_all(tag, "\\[", "")) %>%
      mutate(tag = str_replace_all(tag, "\\]", ""))
  } else {
    df <- df %>%
      select(verse_list, tag)
  }

  return(df)

}



