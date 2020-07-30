library(tidycensus)
library(tidyverse)
library(janitor)

#Census API key
census_api_key(Sys.getenv("CENSUS_API_KEY"))


#What year to pull for census data - ACS 5-year
years <- lst(2018)

my_states <- c("MN")
income_variables <- c(median_hh_income = "B19013_001")


zcta_income <-  map_dfr(
  years,
  ~ get_acs(
    geography = "zcta",
    variables = income_variables,
    year = .x,
    survey = "acs5"
  ),
  .id = "year"
) %>% clean_names()

write.csv(zcta_income, 'zcta_income.csv', row.names=FALSE)

names(metro)

metro <-  metro %>% mutate(geoid2 = as.character(geoid10))

metro <-  left_join(metro, zcta_income %>% select(geoid, estimate), by=c("geoid2"="geoid")) %>% rename(med_income = estimate)

write.csv(metro, 'metro_with_income.csv', row.names=FALSE)