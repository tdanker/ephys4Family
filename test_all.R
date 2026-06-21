# restart R before use (it's safer)

# devtools::test()

lib <- tempfile()
dir.create(lib)


withr::with_libpaths(lib,action = "prefix",  {
  
  devtools::install(".", upgrade="never", quick=TRUE)
  
  devtools::test("../ephys4HAMA")
  devtools::test("../ephys4Patchmaster")
  devtools::test("../ephys4Roboo")
  #devtools::test("../ephys4HiClamp")
  
})
