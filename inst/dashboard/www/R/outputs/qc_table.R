output$qc_table <- DT::renderDT({
  req(ward_data())
  
  # QC 1
  id_1 <- ward_data() |> 
    filter(! ward_code %in% patient_data()$ward_code) |> 
    pull(id)
  
  qc_1 <- tibble(Issue = "Ward forms without any patient", 
                 ODK_ID = id_1)
  
  # QC 2
  id_2 <- patient_data() |> 
    filter(! ward_code %in% ward_data()$ward_code) |> 
    pull(id)
  
  qc_2 <- tibble(Issue = "Patients forms not linked to a ward", 
                 ODK_ID = id_2)
  
  # QC 3
  id_3 <- antibio_data() |> 
    filter(! patient_code %in% patient_data()$patient_code) |> 
    pull(id)
  
  qc_3 <- tibble(Issue = "Antibio forms not linked to a patient", 
                 ODK_ID = id_3)
  
  # QC 4
  id_4 <- microbio_data() |> 
    filter(! patient_code %in% patient_data()$patient_code) |> 
    pull(id)
  
  qc_4 <- tibble(Issue = "Microbio forms not linked to a patient", 
                 ODK_ID = id_4)
  
  tab <- bind_rows(qc_1, qc_2, qc_3, qc_4)
  
  DT::datatable(tab,
                rownames = FALSE,
                filter = "top",
                style = "bootstrap",
                options = list(scrollX = TRUE, scrollY = 300, paging = FALSE, dom = "lrtip"))
})