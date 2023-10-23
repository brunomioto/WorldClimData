#' Download WorldClim v.2.1 bioclimatic data
#'
#' This function allows to download data from WorldClim v.2.1 (https://www.worldclim.org/data/index.html) considering multiple GCMs, time periods and SSPs.
#'
#' @usage download_worldclim(period = 'current', variable = 'bio', year = '2030', gcm = 'mi', ssp = '126', resolution = 10)
#'
#' @param period Can be 'current' or 'future'.
#' @param variable Allows to specify which variables you want to retrieve Possible entries are:
#' 'tmax','tmin','prec' and/or 'bioc'.
#' @param year Specify the year you want to retrieve data. Possible entries are:
#' '2030', '2050', '2070' and/or '2090'. You can  use a vector to provide more than one entry.
#' @param gcm GCMs to be considered in future scenarios. You can use a vector to provide more than one entry.
#'  | **CODE** | **GCM** |
#'  | ---- | ---------------- |
#'  | ac  | ACCESS-CM2 |
#'  | ae  | ACCESS-ESM1-5 |
#'  | bc  | BCC-CSM2-MR |
#'  | ca  | CanESM5 |
#'  | cc  | CanESM5-CanOE |
#'  | ce  | CMCC-ESM2 |
#'  | cn  | CNRM-CM6-1 |
#'  | ch  | CNRM-CM6-1-HR |
#'  | cr  | CNRM-ESM2-1 |
#'  | ec  | EC-Earth3-Veg |
#'  | ev  | EC-Earth3-Veg-LR |
#'  | fi  | FIO-ESM-2-0 |
#'  | gf  | GFDL-ESM4 |
#'  | gg  | GISS-E2-1-G |
#'  | gh  | GISS-E2-1-H |
#'  | hg  | HadGEM3-GC31-LL |
#'  | in  | INM-CM4-8 |
#'  | ic  | INM-CM5-0 |
#'  | ip  | IPSL-CM6A-LR |
#'  | me  | MIROC-ES2L |
#'  | mi  | MIROC6 |
#'  | mp  | MPI-ESM1-2-HR |
#'  | ml  | MPI-ESM1-2-LR |
#'  | mr  | MRI-ESM2-0 |
#'  | uk  | UKESM1-0-LL |
#' @md
#' @param ssp SSPs for future data. Possible entries are: '126', '245', '370' and/or '585'.
#' You can use a vector to provide more than one entry.
#' @param resolution You can select one resolution from the following alternatives: 10, 5, 2.5 OR 30.
#'
#' @details This function will create a folder entitled 'WorldClim_data'.
#' All the data downloaded will be stored in this folder.
#' Note that, despite being possible to retrieve a lot of data at once,
#' it is not recommended to do so, since the data is very heavy.
#'
#' @references https://www.worldclim.org/data/index.html
#'
#'
#' @export
#'
download_worldclim <- function(period = "current",
                               variable = "bio",
                               resolution = 10,
                               # year, #not implemented
                               # gcm, #not implemented
                               # ssp, #not implemented
                               folder_path = "./WorldClim_data",
                               #file_type = "zip",
                               # use_hive = file_type %in% c("zip"),
                               .token = "default"
                               ){
  # fazer o all
  # if(variable == "all"){
  #   variable <- c("bio","elev","prec","srad")
  # }
  rlang::check_installed(c("piggyback (>= 0.1.2)", "fs", "gh"))

  if(.token == "default") .token <- gh::gh_token()

  file_list <- piggyback::pb_list(repo = "brunomioto/WorldClimData",
                                  .token = .token)

  file_download <- file_list[which(
    grepl(paste("worldclim",
                "base",
                "v21",
                period,
                paste0("(",
                       paste(variable,collapse = "|"),
                       ")"),
                paste0(resolution,"m"),
                sep = "_"), x=file_list$file_name)), ,
    drop = FALSE]


  fs::dir_create(file.path(folder_path
                           #, releases
  ))

  cheking_files <- file_download %>%
   dplyr::mutate(exists = fs::file_exists(paste0(file.path(folder_path),
                                           "/",
                                           file_download$file_name)))

  if(length(subset(cheking_files, exists == TRUE)$file_name) > 0){
  cli::cli_alert_info("The following files already exists. Skipping.")
  cli::cli_bullets(subset(cheking_files, exists == TRUE)$file_name)
  }
  if(length(subset(cheking_files, exists == FALSE)$file_name) > 0){
  cli::cli_alert_info("Downloading the following files")
  cli::cli_bullets(subset(cheking_files, exists == FALSE)$file_name)
  }

  # all_releases <- piggyback::pb_releases(repo = "brunomioto/WorldClimData",
  #                                        verbose = FALSE,
  #                                        .token = .token)

  piggyback::pb_download(
    file = subset(cheking_files, exists == FALSE)$file_name,
    dest = folder_path,
    repo = "brunomioto/WorldClimData",
    overwrite = TRUE,
    .token = .token
  )

# unzip
  if(length(subset(cheking_files, exists == FALSE)$file_name) > 0){
  cli::cli_alert_info("Files downloaded. Unzipping...")
  file_download2 <- cheking_files %>%
    dplyr::filter(exists == FALSE,
                  stringr::str_detect(file_name,"\\.zip")) %>%
    dplyr::mutate(file_name2 = stringr::str_remove_all(file_name,"\\.zip"))

  purrr::map(file_download2$file_name2,
             .f = ~unzip(zipfile = paste0(folder_path,"/", .x,".zip"),
                         exdir = paste0(folder_path,"_unzipped/",.x)))
  }

  cli::cli_alert_success("Done")
}

