library(httr)
library(purrr)

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

print(getwd())

write.csv(df, 
          glue::glue("./inst/versions/{Sys.Date()}-hadesPackageVersions.csv"),
          row.names = FALSE)


library(renv)
library(remotes)
renv::init()
purrr::walk2(df$package, df$version, 
             ~install_github(glue::glue("OHDSI/{.x}"),
                                      ref = .y,
                                      dependencies = TRUE, 
                                      upgrade = "always"))
renv::snapshot()

file.copy("renv.lock", "./inst/lockfiles/{Sys.Date()}-HADES-renv.lock")


