# nolint start: object_name_linter. Blame Shiny

# Replacement govuk components to work with Shiny
# These are not well tested for functions that they aren't used for in this app
# (and even then, they could probably be tested better)

govuk_actionButton <- function(inputId, label, icon = NULL, width = NULL, ...) {
  value <- shiny::restoreInput(id = inputId, default = NULL)
  shiny::tags$button(id = inputId,
                     style = htmltools::css(
                       width = htmltools::validateCssUnit(width)
                     ),
                     type = "button",
                     class = "btn btn-default action-button govuk-button",
                     `data-val` = value,
                     `data-module` = "govuk-button",
                     list(shiny:::validateIcon(icon), label),
                     ...)
}

govuk_submitButton <- function(text = "Apply Changes",
                               icon = NULL,
                               width = NULL) {
  shiny::div(
    shiny::tags$button(type = "submit",
      class = "btn btn-primary govuk-button",
      style = htmltools::css(width = htmltools::validateCssUnit(width)),
      `data-module` = "govuk-button",
      list(shiny:::validateIcon(icon), text)
    )
  )
}

govuk_checkboxInput <- function(inputId, label,  value = FALSE, width = NULL) {
  value <- shiny::restoreInput(id = inputId, default = value)
  inputTag <- shiny::tags$input(id = inputId,
    name = inputId,
    type = "checkbox",
    class = "shiny-input-checkbox govuk-checkboxes__input"
  )
  if (!is.null(value) && value) {
    inputTag$attribs$checked <- "checked"
  }
  shiny::div(class = "form-group shiny-input-container govuk-checkboxes",
             `data-module` = "govuk-checkboxes",
             style = htmltools::css(width = htmltools::validateCssUnit(width)),
             shiny::div(class = "checkbox govuk-checkboxes__item",
               shiny::tagList(inputTag,
                 shiny::tags$label(
                   class = "govuk-label govuk-checkboxes__label",
                   `for` = inputId,
                   label
                 )
               )
             ))
}

govuk_generateOptions <- function(inputId,
                                  selected,
                                  inline,
                                  type = "checkbox",
                                  choiceNames,
                                  choiceValues,
                                  session = shiny::getDefaultReactiveDomain()) {
  prefix <- switch(type,
                   "checkbox" = "govuk-checkboxes",
                   "radio" = "govuk-radios")
  options <- mapply(choiceValues, choiceNames, FUN = function(value, name) {
    inputTag <- shiny::tags$input(type = type,
                                  class = paste0(prefix, "__input"),
                                  id = inputId,
                                  name = inputId,
                                  value = value)
    if (value %in% selected) inputTag$attribs$checked <- "checked"
    pd <- shiny:::processDeps(name, session)
    if (inline) {
      shiny::tags$div(class = paste0(prefix, "__item"),
        inputTag,
        shiny::tags$label(class = paste0(type,
                                         "-inline govuk-label ",
                                         prefix,
                                         "__label"),
                          pd$html,
                          pd$deps,
                          `for` = inputId)
      )
    } else {
      shiny::tags$div(class = paste0(prefix, "__item"),
                      inputTag,
                      shiny::tags$label(
                        class = paste0("govuk-label ",
                                       prefix,
                                       "__label"),
                        pd$html,
                        pd$deps,
                        `for` = name
                      ))
    }
  }, SIMPLIFY = FALSE, USE.NAMES = FALSE)
  shiny::div(class = paste0("shiny-options-group ", prefix),
             `data-module` = prefix,
             options)
}

govuk_checkboxGroupInput <- function(inputId,
                                     label,
                                     choices = NULL,
                                     selected = NULL,
                                     inline = FALSE,
                                     width = NULL,
                                     choiceNames = NULL,
                                     choiceValues = NULL) {
  if (is.null(choices) && is.null(choiceNames) && is.null(choiceValues)) {
    choices <- character(0)
  }
  args <- shiny:::normalizeChoicesArgs(choices, choiceNames, choiceValues)
  selected <- shiny::restoreInput(id = inputId, default = selected)
  if (!is.null(selected)) selected <- as.character(selected)
  options <- govuk_generateOptions(inputId,
                                   selected,
                                   inline,
                                   "checkbox",
                                   args$choiceNames,
                                   args$choiceValues)
  divClass <- paste("form-group",
                    "shiny-input-checkboxgroup",
                    "shiny-input-container",
                    "govuk-form-group",
                    sep = " ")
  if (inline) divClass <- paste(divClass, "shiny-input-container-inline")
  inputLabel <- shiny:::shinyInputLabel(inputId, label)
  shiny::tags$div(id = inputId,
    style = htmltools::css(width = htmltools::validateCssUnit(width)),
    class = divClass,
    role = "group",
    `aria-labelledby` = inputLabel$attribs$id,
    inputLabel, options
  )
}

# Here we depart from the real GovUK input types because the date selector is
# too useful. This isn't the best solution, it uses the standard shiny solution
# and then adds in the govuk styles, but it relies on Shiny never changing the
# format they use for date inputs

govuk_dateInput <- function(inputId,
                            label,
                            value = NULL,
                            min = NULL,
                            max = NULL,
                            format = "dd-mm-yyyy",
                            startview = "month",
                            weekstart = 1) {
  dip <- shiny::dateInput(inputId,
                          label,
                          value,
                          min,
                          max,
                          format,
                          startview,
                          weekstart)
  dip$children[[1]]$attribs$class <- paste0(dip$children[[1]]$attribs$class,
                                            " govuk-label")
  dip$children[[2]]$attribs$class <- paste0(dip$children[[2]]$attribs$class,
                                            " govuk-input")
  return(dip)
}

govuk_dateRangeInput <- function(inputId,
                                 label,
                                 start = NULL,
                                 end = NULL,
                                 min = NULL,
                                 max = NULL,
                                 format = "dd-mm-yyyy",
                                 startview = "month",
                                 weekstart = 1,
                                 language = "en",
                                 separator = " to ",
                                 width = NULL,
                                 autoclose = TRUE) {
  dri <- shiny::dateRangeInput(inputId,
                               label,
                               start,
                               end,
                               min,
                               max,
                               format,
                               startview,
                               weekstart,
                               language,
                               separator,
                               width,
                               autoclose)
  dri$children[[1]]$attribs$class <- paste0(dri$children[[1]]$attribs$class)
  dri$children[[2]]$children[[1]]$attribs$class <- paste0(
    dri$children[[2]]$children[[1]]$class,
    " govuk-input"
  )
  dri$children[[2]]$children[[3]]$attribs$class <- paste0(
    dri$children[[2]]$children[[3]]$class,
    " govuk-input"
  )
  return(dri)
}

govuk_helpText <- function(...) {
  shiny::span(class = "govuk-body", ...)
}

# This still restricts inputs to numbers, but it doesn't have the up/down arrows
# any more. Something tells me that they're an accessibility disaster, so I'm
# just going to ignore them as that looks long.
govuk_numericInput <- function(inputId,
                               label,
                               value,
                               min = NA,
                               max = NA,
                               step = NA,
                               width = NULL) {
  input <- shiny::numericInput(inputId, label, value, min, max, step, width)
  input$atribs$class <- paste0(input$attribs$class, " govuk-form-group")
  input$children[[1]]$attribs$class <- paste0(
    input$children[[1]]$attribs$class,
    " govuk-label"
  )
  input$children[[2]]$attribs$class <- paste0(
    input$children[[2]]$attribs$class,
    " govuk-input"
  )
  return(input)
}

govuk_radioButtons <- function(inputId,
                               label,
                               choices = NULL,
                               selected = NULL,
                               inline = FALSE,
                               width = NULL,
                               choiceNames = NULL,
                               choiceValues = NULL) {
  args <- shiny:::normalizeChoicesArgs(choices, choiceNames, choiceValues)
  selected <- shiny::restoreInput(id = inputId, default = selected)
  selected <- if (is.null(selected)) {
    args$choiceValues[[1]]
  } else {
    as.character(selected)
  }

  if (length(selected) > 1) stop("The 'selected' argument must be of length 1")

  options <- govuk_generateOptions(inputId,
                                   selected,
                                   inline,
                                   "radio",
                                   args$choiceNames,
                                   args$choiceValues)

  divClass <- paste("form-group",
                    "shiny-input-radiogroup",
                    "shiny-input-container",
                    "govuk-form-group",
                    sep = " ")
  if (inline) divClass <- paste(divClass, "shiny-input-container-inline")

  inputLabel <- shiny:::shinyInputLabel(inputId, label)
  shiny::tags$div(id = inputId,
    style = htmltools::css(width = htmltools::validateCssUnit(width)),
    class = divClass,
    role = "radiogroup",
    `aria-labelledby` = inputLabel$attribs$id,
    inputLabel,
    options
  )
}

# Because Selectize is hard currently this just overwrites the css for
# selectize. What it *should* do is to apply the styles only to the govuk
# selectizes in case for some reason we wanted both in a document. The general
# idea of multiple stylesheets for different parts of the page makes sass sad,
# so we're not doing that for now. Instead there's just a symbolic select

govuk_selectInput <- function(inputId,
                              label,
                              choices,
                              selected = NULL,
                              multiple = FALSE,
                              selectize = TRUE,
                              width = NULL,
                              size = NULL) {
  shiny::selectInput(inputId,
                     label,
                     choices,
                     selected,
                     multiple,
                     selectize,
                     width,
                     size)
}

# The guidance is very specific that you can't have default text inputs or
# placeholders on govuk, so we've removed the value option here
govuk_textInput <- function(inputId, label, width = NULL) {
  shiny::div(class = "form-group shiny-input-container govuk-form-group",
    style = htmltools::css(width = htmltools::validateCssUnit(width)),
    shiny:::shinyInputLabel(inputId, label),
    shiny::tags$input(id = inputId,
                      type = "text",
                      class = "shiny-input-text form-control govuk-input")
  )
}

# nolint end: object_name_linter.