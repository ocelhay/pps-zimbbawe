# Remove records entered during test phase ------------------------------------

ward_data_odk <- ward_data_odk |> 
  filter(system_submission_date >= as.Date("2022-03-01"))

patient_data_odk <- patient_data_odk |> 
  filter(system_submission_date >= as.Date("2022-03-01"))

antibio_data_odk <- antibio_data_odk |> 
  filter(system_submission_date >= as.Date("2022-03-01"))

microbio_data_odk <- microbio_data_odk |> 
  filter(system_submission_date >= as.Date("2022-03-01"))


# Keep only records relevant to connected account -----------------------------
# TODO: use column hospital_code in ceredentials_GITIGNORE file.

if (cred$hospital_code == "all")  message("All records are displayed.")
