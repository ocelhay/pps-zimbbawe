output$ward_table <- DT::renderDT({
  req(ward_data())
  DT::datatable(ward_data(),
                rownames = FALSE,
                filter = "top",
                style = "bootstrap",
                options = list(scrollX = TRUE, scrollY = 300, paging = FALSE, dom = "lrtip"))
})

output$patient_table <- DT::renderDT({
  req(patient_data())
  DT::datatable(patient_data(),
                rownames = FALSE,
                filter = "top",
                style = "bootstrap",
                options = list(scrollX = TRUE, scrollY = 300, paging = FALSE, dom = "lrtip"))
})

output$antibio_table <- DT::renderDT({
  req(antibio_data())
  DT::datatable(antibio_data(),
                rownames = FALSE,
                filter = "top",
                style = "bootstrap",
                options = list(scrollX = TRUE, scrollY = 300, paging = FALSE, dom = "lrtip"))
})

output$microbio_table <- DT::renderDT({
  req(microbio_data())
  DT::datatable(microbio_data(),
                rownames = FALSE,
                filter = "top",
                style = "bootstrap",
                options = list(scrollX = TRUE, scrollY = 300, paging = FALSE, dom = "lrtip"))
})