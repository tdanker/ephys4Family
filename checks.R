library(dplyr)
list.dirs(recursive = FALSE)
github_repos <- dir(pattern = "git*", full.names = TRUE)


desc_files <- list.files(
  recursive = TRUE, pattern = "DESCRIPTION",
  path = github_repos, full.names = TRUE
)

# check the Remotes field in all DESCRIPTION files
desc_files |>
  lapply(\(f) {
    dcf <- read.dcf(f, fields = "Remotes")
    if (!is.na(dcf[1])) {
      data.frame(package = basename(dirname(f)), remotes = dcf[1])
    }
  }) |>
  bind_rows()

# check the Install tipp in  all README files
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


# pull all repos
for (repo in github_repos) {
  message(">>> ", repo)
  system2("git", c("-C", repo, "pull"))
}

system("git config --global user.name 'timm'")
system("git config --global user.email 'tim@me.de'")


# Git add, commit, push all repos
commit_msg <- shQuote("fixed Remotes in DESCRIPTION")

for (repo in github_repos) {
  message(">>> ", repo)
  system2("git", c("-C", repo, "add", "-A"))
  system2("git", c("-C", repo, "commit", "-m", commit_msg))
  system2("git", c("-C", repo, "push"))
}

# status for all repos
for (repo in github_repos) {
  message(">>> ", repo)
  system2("git", c("-C", repo, "status"))
}
