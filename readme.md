# Sample GovUK App

Very simple app that uses the [GovUK Design System](https://design-system.service.gov.uk/). 

# Quickstart Guide

Apparently this doesn't run that well in RStudio for reasons I don't really understand. (This seems to be an RStudio problem, and not an R problem). 

## Not RStudio

If you're *not* in RStudio, set your working directory to the top of this directory (probably a folder called "govukshiny"), and just run `components.R` and `app.R` in either order and then run `run_preview_app()`. 


## RStudio

If you *are* in RStudio, it tries to *help* and the buttons to "run" and "source" are replaced by "run App" which steadfastly refuses to work. You still need to set the working directory to "govukshiny", and run `components.R` by pressing "source" in the top-right of the window but you will need to run the contents of `app.R` manually, probably by highlighting everything in the file and pressing `ctrl + enter`. 

Then run `run_preview_app()` in the terminal.

---

# How it works

All of the components are optional except the selectize component, which overwrites the default shiny selectize box. If for some reason you need both styles in the same sheet, this won't work. 

The main difference here is that rather than using Shiny's `fluidPage` function to make the page, we use the `htmlTemplate` function to define a custom html page using the [GovUK page template](https://design-system.service.gov.uk/styles/page-template/), which is then populated with R Shiny objects.

---

# Tabs

Sorry that this is all just editing the template rather than using shiny properly!

Here we leverage the way that govuk does tabs to cheat some in. 

## Navigation

(This is on line 48+ of [template.html](templates/template.html))

Inside the `govuk-header__content` div in the template, we add a menu

``` html
    <nav aria-label = "Menu" class = "govuk-header__navigation">
        <!-- An accessibility button to navigate to the page if you press tab -->
        <button type = "button" class = "govuk-header__menu-button govuk-js-header-toggle" aria-controls="navigation" hidden = "true"> 
        <!--list of tabs-->
        <ul id = "navigation" class = "govuk-header__navigation-list" role = "tablist">
            <!--link for tab1-->
            <li class = "govuk-header__navigation-item govuk-header__navigation-item--active">      <a class = "govuk-header__link" aria-controls="tab1" role = "tab" data-toggle="tab" href = "#tab1">
                Tab 1
              </a>
            </li>
            <!--link for tab2-->
            <li class = "govuk-header__navigation-item">
                <a class = "govuk-header__link" aria-controls="tab2" role = "tab" data-toggle="tab" href = "#tab2">
                 Tab 2
                </a>
            </li>
        </ul>
    </nav>
```

This is an unholy combination of the way that bootstrap and govuk do tabs, and hijacks the styling for the page menu to cover up the tabs menu.

The tab buttons are an unordered list of `<li>` with class `govuk-header__navigation-item` (the first one also has `govuk-header__navigation-item--active` to highlight it on page load). Each contains a link with a load of bootstrap settings, (I think `aria-controls` is an accessibility feature, `role` and `data-toggle` I don't remember)

## Contents

We then want to add the contents of the tabs. This is much easier. 

All of the main page content needs to be inside the `<main>` tags, mostly so the accessability components can find it. 

Other than that we replace the `{{contents}}` shiny object which contains a single page with an individual object for each tab (here `{{tab1}}` and `{{tab2}}`)

``` html
    <main class="govuk-main-wrapper" id="main-content" role="main">
      <div class="tab-content">
        <div role="tab-panel" class="tab-pane active" id="tab1"> {{ tab1 }}</div>
        <div role="tab-panel" class="tab-pane" id="tab2"> {{ tab2 }}</div>
      </div>
    </main>
```

(So your ui function might be something like )

``` r
  ui <- shiny::htmlTemplate("templates/template.html",

    tab1 = fluidPage(h1("Tab 1", class = "govuk-heading-l")),
    tab2 = fluidPage(h1("Tab 2", class = "govuk-heading-l"))
  )
```

which would make correctly formatted govuk headings as described [here](https://design-system.service.gov.uk/styles/headings/).


## A short note on performance

This will load the contents of **EVERY TAB** when you load the page, and just hide the tabs that aren't currently open, so something to be aware of if you have some complicated tabs. This can be avoided with clever use of modules, but is probably not worth it. 