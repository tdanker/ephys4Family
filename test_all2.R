# restart R before use (it's safer)

# devtools::test()

lib <- tempfile()
dir.create(lib)


withr::with_libpaths(lib,action = "replace",  {
  
  install.packages("pak")   # required for devtools::install
  install.packages("callr") # required for devtools::install
  
  devtools::install("github_ephys4Patchmaster/", 
                    upgrade=TRUE, 
                    quick=TRUE, 
                    dependencies = TRUE #this is required to also install Suggests like ephysdata. 
                    )
  
  
  devtools::test("github_ephys4Patchmaster/") #ok 22.6.2026
  
  
})


withr::with_libpaths(lib,action = "replace",  {
  
  # WARNING: 
  # These two are not declared in Suggests, but needed in tests (will be removed soon). 
  devtools::install("github_ephys4HAMAMATZU/", quick=TRUE)  
  devtools::install("github_ephys4Roboo/", quick=TRUE)
  
  
  devtools::test("github_ephys4R/")    #ok 22.6.2026
  
  
})
