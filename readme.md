# Sample GovUK App

Very simple app that uses the GovUK styling 

Look at `run_preview_app()` for details, but basically it uses templates

---

# Tabs

Sorry that this is all just editing the template rather than using shiny properly!

Currently, everything is done using a single input, `{{contents}}` in this section:

``` html
    <main class="govuk-main-wrapper" id="main-content" role="main">
      {{contents}}
    </main>
````

but we can instead leverage the way that govuk does tabs to cheat some in. 

## Navigation

(Part of this is dummied out on line 45+ of [template.html](templates/template.html))

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