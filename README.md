
<!-- README.md is generated from README.Rmd. Please edit that file -->

# WorldClimData

<!-- badges: start -->
<!-- badges: end -->

The goal of WorldClimData is to present a faster way to download
WorldClim data

## Installation

You can install the development version of WorldClimData from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("brunomioto/WorldClimData")
```

## Example

The function `download_worldclim` will download worldclim zipped data to
a **WorldClim_data** folder and the unzipped .tiff files to a
**WorldClim_data_unzipped** folder inside the working directory.

``` r
library(WorldClimData)
```

``` r
download_worldclim(variable = "elev",
                   resolution = 10)
#> i Downloading the following files
#> worldclim_base_v21_current_elev_10m.zip
#> i Files downloaded. Unzipping...
#> v Done
```
