output$indicators_table <- DT::renderDT({
  req(ward_data())
  
  tab <- tribble(
    ~Indicator, ~Value,
    "Number of ward forms", ward_data() |> nrow(),
    "Number of patients forms", patient_data() |> nrow(),
    "Number of antibio forms", antibio_data() |> nrow(),
    "Number of microbio forms", microbio_data() |> nrow()
  )
  
  DT::datatable(tab,
                rownames = FALSE,
                filter = "top",
                style = "bootstrap",
                options = list(scrollX = TRUE, scrollY = 300, paging = FALSE, dom = "lrtip"))
})