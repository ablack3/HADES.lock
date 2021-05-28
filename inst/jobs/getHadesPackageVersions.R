
# order matters here
hadesPackages <- c("Andromeda","SqlRender", "DatabaseConnector", "BigKnn","CirceR","CohortDiagnostics","CohortMethod","Cyclops","EmpiricalCalibration","Eunomia","EvidenceSynthesis","FeatureExtraction","Hydra","MethodEvaluation","OhdsiSharing","ParallelLogger","PatientLevelPrediction","ROhdsiWebApi","SelfControlledCaseSeries","SelfControlledCohort")

getHadesPackageVersion <- function(packageName){
  r <- httr::GET(glue::glue("https://api.github.com/repos/OHDSI/{packageName}/tags"))
  httr::stop_for_status(r)
  httr::content(r)[[1]]$name
}

# getHadesPackageVersion(hadesPackages[[2]])

hadesPackageVersions <- purrr::map_chr(hadesPackages, getHadesPackageVersion)

df <- data.frame(package = hadesPackages, version = hadesPackageVersions)

# read latest version file
# sort(list.files("versions"))[[1]]

print(paste("working directory is", getwd()))

write.csv(df,
          glue::glue("./inst/versions/{Sys.Date()}-hadesPackageVersions.csv"),
          row.names = FALSE)

renv::init()
remotes::install_github("OHDSI/Hades", dependencies = TRUE, upgrade = "always", quiet = TRUE)

# purrr::walk2(df$package, df$version, 
#              ~install_github(glue::glue("OHDSI/{.x}"),
#                                       ref = .y,
#                                       dependencies = TRUE, 
#                                       upgrade = "always"))
renv::snapshot()

file.copy("renv.lock", glue::glue("./inst/lockfiles/{Sys.Date()}-HADES-renv.lock"))


