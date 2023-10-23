
<!-- README.md is generated from README.Rmd. Please edit that file -->

# WorldClimData

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
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

## Data

Currently, WorldClimData don’t have all WorldClim data.

There is data only for **current** period and the following resolution:

- 10’ resolution: All the variables
  (“bio”,“elev”,“prec”,“srad”,“tavg”,“tmax”,“tmin”,“vapr”,“wind”)

- 5’ resolution: All the variables
  (“bio”,“elev”,“prec”,“srad”,“tavg”,“tmax”,“tmin”,“vapr”,“wind”)

- 2.5’ resolution: “elev”,“prec”

- 30” resolution:

## Example

The function `download_worldclim` will download worldclim zipped data to
a **WorldClim_data** folder and the unzipped .tiff files to a
**WorldClim_data_unzipped** folder inside the working directory.

The folder name can be specified inside the function using the
`folder_path` argument.

``` r
library(WorldClimData)
```

``` r
download_worldclim(period = "current",
                   variable = "elev",
                   resolution = 10,
                   folder_path = "./WorldClim_data")
#> i Downloading the following files
#> worldclim_base_v21_current_elev_10m.zip
#> i Files downloaded. Unzipping...
#> v Done
```

The example above creates 2 folders (WorldClim_data and
WorldClim_data_unzipped) and downloads data of **Elevation** variable
for **Current** period with a **10’** resolution.

``` r
Working directory
├── WorldClim_data
│   └── worldclim_base_v21_current_elev_10m.zip
└── WorldClim_data_unzipped
    └── wc2.1_10m_elev.tif
```
