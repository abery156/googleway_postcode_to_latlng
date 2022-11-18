#library -------
pacman::p_load(tidyverse, googleway)

# get data ---------
download.file(url = 'https://www.post.japanpost.jp/zipcode/dl/roman/ken_all_rome.zip',
              destfile = './data/raw/zip/ken_all_rome.zip')
unzip('./data/raw/zip/ken_all_rome.zip', exdir = './data/raw/')
df_raw <- read_csv('./data/raw/KEN_ALL_ROME.csv',
                   col_names = c('postcode'),
                   col_types = cols_only(postcode = col_character()),
                   locale = locale(encoding = 'shift-jis'))

# google map api --------------
key <- rstudioapi::askForPassword()

## test head 5rows -------- 
df_head <- df_raw %>% slice_head(n = 5)
df_temp <- map_dfr(df_head$postcode,
                   ~ {
                     tibble(
                       postcode = .,
                       geocode_coordinates(google_geocode(address = ., key = key , simplify = TRUE))
                     )
                   }
)

## full data ------------

### warning:
### it takes cost to get all data.
### up to 200$ you can get free per month.

# df_post_latlng <- 
#   map_dfr(df_raw$postcode,
#           ~ {
#             tibble(
#               postcode = .,
#               geocode_coordinates(google_geocode(address = ., key = key , simplify = TRUE))
#             )
#           }
#   )
