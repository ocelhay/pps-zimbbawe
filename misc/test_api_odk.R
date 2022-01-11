library(ruODK)  # remotes::install_github("ropensci/ruODK@main")

odk_password <- rstudioapi::askForPassword("Enter your password")

ru_setup(
  url = "https://fieldcollection.net/",
  un = "olivier.celhay@gmail.com",
  pid = 2,
  pw = odk_password
)

ward_data     <- odata_submission_get(fid = "pps_ward")
patient_data  <- odata_submission_get(fid = "pps_patient")
antibio_data  <- odata_submission_get(fid = "pps_antibio")
microbio_data <- odata_submission_get(fid = "pps_microbiology")