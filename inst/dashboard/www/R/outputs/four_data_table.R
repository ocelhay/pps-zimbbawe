output$ward_table <- DT::renderDT({
  req(ward_data())
  DT::datatable(ward_data())
})

output$patient_table <- DT::renderDT({
  req(patient_data())
  DT::datatable(patient_data())
})

output$antibio_table <- DT::renderDT({
  req(antibio_data())
  DT::datatable(antibio_data())
})

output$microbio_table <- DT::renderDT({
  req(microbio_data())
  DT::datatable(microbio_data())
})