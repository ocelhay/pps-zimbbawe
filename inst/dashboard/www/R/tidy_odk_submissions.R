ward_data_odk <- ward_data_odk |> 
  transmute(
    id,
    survey_date, 
    survey_quarter = survey_id, 
    hospital_code_final = if_else(hospital_code == "Other", hospital_code_other, hospital_code),
    ward_name, 
    ward_code, 
    ward_type, 
    ward_specialty, 
    total_patients, 
    eligible_patients, 
    included_patients, 
    comments,
    system_submission_date = as.Date(system_submission_date))

patient_data_odk  <- patient_data_odk |> 
  transmute(
    id,
    survey_date, 
    survey_id, 
    hospital_code_final = if_else(hospital_code == "Other", hospital_code_other, hospital_code),
    ward_name, 
    ward_code, 
    patient_code, 
    patient_gender, 
    age_missing, 
    patient_category, 
    pre_term, 
    age, 
    age_unit, 
    weight, 
    admission_date, 
    surgery_since_admission, 
    central_catheter, 
    peripheral_catheter, 
    urinary_catheter, 
    intubation, 
    patient_antibiotic_bool, 
    patient_antibiotic_nb, 
    malaria_status, 
    tb_status, 
    hiv_status, 
    hiv_on_art, 
    hiv_cd4_count, 
    mc_cabe_score, 
    malnutrition_status, 
    copd_status, 
    transfer_from_hospital, 
    transfer_from_non_hospital, 
    hospital_90_days, 
    type_surgery_admission, 
    comments,
    system_submission_date = as.Date(system_submission_date)
  )


antibio_data_odk  <- antibio_data_odk |> 
  transmute(
    id,
    survey_date,
    survey_id,
    hospital_code, 
    hospital_code_other,
    ward_code, 
    patient_code, 
    meta_instance_id, 
    system_submission_date = as.Date(system_submission_date)
  )

microbio_data_odk <- microbio_data_odk |> 
  mutate(
    system_submission_date = as.Date(system_submission_date)
  )