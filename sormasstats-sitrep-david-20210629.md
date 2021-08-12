# Towards an automatically generated sitrep in SORMAS Stats 
Sugestions for David Zoch

29 June 2021

Here you'll have a look at what reference sitreps look like and generate a first draft of your own sitrep.

(After that, two tasks will remain: precisely define what exactly we want in the sitrep which will include talking with users; and implementing in SORMAS Stats, which will necessitate a number of adjustements, e.g., how to get the data or whether to use the same plotting functions as in the web app.)

## Analysis of references

1. Please look at a number of Covid-19 situation reports ("sitreps") from WHO, Nigeria CDC, and RKI. For example for each institution the last 3, as well as two or three from 6 months ago or so.
https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports
https://ncdc.gov.ng/diseases/sitreps/?cat=14&name=An%20update%20of%20COVID-19%20outbreak%20in%20Nigeria
https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Situationsberichte/Gesamt.html
2. Task: Identify and characterize common components, within and between institutions, that you think could be automated: numbers, tables, plots, text blocks and section titles, as well as layout, logos, ..., that are always or almost always there; also interesting small changes, which could come in the way of automation: how important are they, would it be ok to ignore them?
3. You can choose how you want to document these components... I'd suggest highlighting in one representative report for each institution with different colors for different types of components (e.g., linked to data such as incidence, meta-data of the report such as date of publication) and/or adding comments.
4. Critical appraisal: What, in the reports, do you find interesting and well done? What do you find not great? How would you improve them?

Important: Don't put in too much work and approach this in a way most convenient for you. It doesn't have to be a systematic, deep review, the goal is for us to have a feeling for the challenges and possibilities of automating such reports; from there we'll be able to better formulate concrete requirements and make a plan for later development.

## First draft sitrep based on test data

### Report

1. A Word document with an appropriate title and date of generation in a readable format, e.g., "29 June 2021". Germany will be used as an example, but, when not in Latin (see below), text should be in English.
2. It starts with six indicators: total case count and new cases reported since yesterday; seven-day incidence and change since yesterday; total death count and new deaths since yesterday.
3. It should have four sections, each with an appropriate, numbered section title: introduction, epidemic dynamic, regional situation, remarks.
4. Each section should be filled with one to three paragraphs of lorem ipsum, each paragraph of different length, starting with a capital letter and ending with a colon (the goal is that it looks real).
5. Section epidemic dynamic should also contain four plots with appropriate captions: 
   - one time series with confirmed case count by reporting date, 
   - one time series of case counts by date of onset of disease, 
   - one time series of number of hospitalizations by date of hospitalization, 
   - one distribution of death incidences according to 5-year age groups plus 80+ (as found in the population data set suggested below) and sex (for the sex "diverse" we don't have population numbers, use e.g. 0.01% of the total; *if* there happens to be more deaths than the population of a given sex, assign the value `NA` to the corresponding incidence, which should be displayed in a different way than an incidence of 0; you don't need to take that possibility into account if it doesn't happen). 
   - N.B. Better if the plots are in a Word format (and thus editable), but not necessary.
6. Section regional situation should also contain one table and one plot with appropriate captions: 
    - The table should have 16 rows (one for each federal state (Bundesland)) and nine columns: name of the federal state, total number of confirmed cases, number of new confirmed cases since yesterday, current seven day incidence, change of seven day incidence since yesterday, same as with confirmed cases but with hospitalizations as well as deaths. The table should be a Word table (and thus editable).
    - The plot is a map, at the county level (NUTS-3, i.e., Landkreise and Kreisfreie Städte) of the current seven day incidence. The county considered is the reporting county (`health_authority` in the test data).

### Programming

Use test data generated with the package `sormasdatagen`, with default parameters (see the README for instructions): https://gitlab.com/stephaneghozzi/sormasdatagen
I'd recommend generating them once and saving the result as an R object (either rda or rds).
For the map: `GetGeoData()` (without arguments) returns shapes and pairwise distances for Germany's counties (Kreise). To get the shapes in a variable `geo_shapes` you can write: `geo_shapes <- GetGeoData()$geoshapes`

To compute incidences you'll need population data. You can take the values for 2018 found here: https://raw.githubusercontent.com/ostojanovic/BSTIM/master/data/raw/germany_population_data.csv
This table can also be used for matching counties (Kreise) and federal states (Bundesländer).

Incidence is defined as 100,000 times the number of cases divided by the population number of the group of interest. For the seven day incidence we take the sum of cases from the last seven days (including today) as the numerator.

All pieces of code that are used more than once or are a bit long and risk making reading one block hard to follow should be written as functions. These functions should either be written each in their own script, in which case the script has the name of the function, or, if they are short and generic, combined in a script on a particular topic (could be plots for example, or computation of incidences), or even, if really general, under in a script utils.R.

I'd recommend working with an RStudio project in a new directory (that way don't have to worry much about paths: They are all relative to the directory of the project). It is good practice to have data in a data/ subfolder and scripts in R/, with the possible exception of a main script which calls the highest order functions.

### Remarks

Computing the incidences might be the biggest challenge. If you feel you're not getting anywhere first let me know, and then, if that's too complicated, you can replace them with any similar quantity that's easier to compute, e.g., total case count, new cases since yesterday, or such.

This is now surely more work than can be done in one week, so no stress :) My guesstimate would be something like at the very least six full days, so about two to three weeks... But please do share any milestone you feel you have reached, e.g., scripts organized and pipeline built with dummy or empty, but briefly described, functions; report generated but with plots or tables based on random dummy data; one R object produced with current seven-day incidence computed at the county level. I'm happy to discuss such questions as well: how to approach such a project, define milestones, etc.

