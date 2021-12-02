library(ruODK)  # remotes::install_github("ropensci/ruODK@main")

# If not using RStudio, replace rstudioapi::askForPassword("Enter your password")
# with a string containing the password
odk_password <- rstudioapi::askForPassword("Enter your password")

ru_setup(
  url = "https://fieldcollection.net/",
  un = "olivier.celhay@gmail.com",
  pw = odk_password,
  pid = 2,
  fid = "pps_patient"
)

patient_data <- odata_submission_get()