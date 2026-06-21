pattern <- "CHECK"
setwd("github_ephys4R/")
# Find the latest matching commit
commit <- system2(
  "git",
  c("rev-list", "HEAD", "--grep", pattern, "-n", "1"),
  stdout = TRUE
)

if (length(commit) == 0 || commit == "") {
  stop(sprintf("No commit found matching '%s'", pattern))
}

# Count commits between that commit and HEAD
distance <- system2(
  "git",
  c("rev-list", "--count", sprintf("%s..HEAD", commit)),
  stdout = TRUE
)

distance <- as.integer(distance)

cat(sprintf(
  "Latest matching commit: %s\nCommits from HEAD: %d\n",
  commit,
  distance
))



message <- system2(
  "git",
  c("show", "--no-patch", "--oneline", commit),
  stdout = TRUE
)

cat(sprintf(
  "%d commits from HEAD: %s\n",
  distance,
  message
))
setwd("..")
