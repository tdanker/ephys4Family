# Maintenance Routines for the ephys4 Family ---------------------------------

library(dplyr)
github_repos <- dir(pattern = "git*", full.names = TRUE)


## Status for all repos -------------------------------------------------------
for (repo in github_repos) {
  message(">>> ", repo)
  system2("git", c("-C", repo, "status"), stdout = TRUE)->msg
  if(msg[4]=="nothing to commit, working tree clean"){
    cli::cli_inform(c("v"=msg[4]))
  }else{
    cli::cli_inform(c("x"=msg[4]))
  }
  
}




## Pull all repos --------------------------------------------------------------
for (repo in github_repos) {
  message(">>> ", repo)
  system2("git", c("-C", repo, "pull"))
}




## Check the Remotes: field in all DESCRIPTION files ---------------------------

desc_files <- list.files(
  recursive = TRUE, pattern = "DESCRIPTION",
  path = github_repos, full.names = TRUE
)

desc_files |>
  lapply(\(f) {
    dcf <- read.dcf(f, fields = "Remotes")
    if (!is.na(dcf[1])) {
      data.frame(package = basename(dirname(f)), remotes = dcf[1])
    }
  }) |>
  bind_rows() %>% mutate(has_ephysdata=stringr::str_detect(remotes, "ephysdata"))




## Check the install tipp in  all README files  -------------------------------
readme_files <- list.files(
  recursive = TRUE, pattern = "README.Rmd",
  path = github_repos, full.names = TRUE
)

readme_files |>
  lapply(\(f) {
    README <<- readLines(f)
    if (!is.na(README[1])) {
      data.frame(package = basename(dirname(f)), remotes = c(README[grepl("remotes::install_github", README)],"")[1]) 
    }
  }) |>
  bind_rows()




## Commit to all repos (discouraged)-------------------------------------------
#system("git config --global user.name 'timm'")
#system("git config --global user.email 'tim@me.de'")

# if(FALSE){
#   # Git add, commit, push all repos
#   commit_msg <- shQuote("fixed Remotes in DESCRIPTION")
#   
#   for (repo in github_repos) {
#     message(">>> ", repo)
#     #system2("git", c("-C", repo, "add", "-A"))
#     #system2("git", c("-C", repo, "commit", "-m", commit_msg))
#     #system2("git", c("-C", repo, "push"))
#   }
# }
# 
