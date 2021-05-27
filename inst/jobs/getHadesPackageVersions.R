library(httr)
library(purrr)

hadesPackages <- c("Andromeda","BigKnn","CirceR","CohortDiagnostics","CohortMethod","Cyclops","DatabaseConnector","EmpiricalCalibration","Eunomia","EvidenceSynthesis","FeatureExtraction","Hydra","MethodEvaluation","OhdsiSharing","ParallelLogger","PatientLevelPrediction","ROhdsiWebApi","SelfControlledCaseSeries","SelfControlledCohort","SqlRender")

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

print(getwd())

write.csv(df, 
          glue::glue("./inst/versions/{Sys.Date()}-hadesPackageVersions.csv"),
          row.names = FALSE)

