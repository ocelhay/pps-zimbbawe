output$indicators_table <- DT::renderDT({
  req(ward_data())
  
  tab <- tribble(
    ~Indicator, ~Value,
    "Number of ward form records", ward_data() |> nrow(),
    "Number of patient/indication form records", patient_data() |> nrow(),
    "Number of antibio form records", antibio_data() |> nrow(),
    "Number of microbio form records", microbio_data() |> nrow()
  )
  
  DT::datatable(tab,
                rownames = FALSE,
                filter = "none",
                style = "bootstrap",
                options = list(scrollX = TRUE, scrollY = 300, paging = FALSE, dom = "lrtip"))
})