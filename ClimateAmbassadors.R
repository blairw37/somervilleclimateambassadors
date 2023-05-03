library(tidyverse)
library(sf)
library(ggmap)

# Data from https://hudgis-hud.opendata.arcgis.com/datasets/HUD::low-to-moderate-income-population-by-tract/about
# Data from https://data.somervillema.gov/GIS-data/Neighborhoods/n5md-vqta
# Data from https://data.somervillema.gov/GIS-data/Open-Space/9i64-4hby

# Importing Data
neighborhoods<-st_read('datasets/Neighborhoods/Neighborhoods.shp')
open_space<-st_read('datasets/OpenSpace/OpenSpace.shp')
ltm_income<-st_read('datasets/Low_to_Moderate_Income_Population_by_Tract_v2/Low_to_Moderate_Income_Population_by_Tract.shp')
somerville_ct<-read.csv('datasets/somerville_census_tracts.csv')

# Append 25025 to census tract IDs for other census tracts
somerville_ct$CENSUS_TRACT_ID = paste('25017', somerville_ct$CENSUS_TRACT_ID, sep="")

somerville_ct_list<-as.list(somerville_ct$CENSUS_TRACT_ID)

# Filter
ltm_income<-ltm_income %>%
  filter(GEOID %in% somerville_ct_list)

# Maps
somerville<-get_map(location=c(left = -71.15, 
                           bottom = 42.36, 
                           right = -71.05, 
                           top = 42.43),
                source="stamen")
somerville_map<-ggmap(somerville)
somerville_map

ltm_income_map<-somerville_map + geom_sf(data=ltm_income[ltm_income$LOWMODPCT>0,], aes(fill=LOWMODPCT), alpha = 0.8, inherit.aes = FALSE) +
  scale_fill_gradient(high = "purple", low = "orange") +
  labs(fill = "Percentage of \nLow to Moderate Income")
ltm_income_map
