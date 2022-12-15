################
### Function ###
################

## To conveniently calculate Jaro-Winkler similarity, we need to use the package RecordLinkage,
## which only works with R version 4.2.2. Upgrade your R!
library(RecordLinkage)

approxMatch = function(base_series, reference_series){ 
  # This function returns a data frame in which:
  # The first column is the base_series, which is the set of unique items from one of the series
  # The second column contains the item from the second itemset that the algorithm "believes" to match with the item in the same row on the first column, based on
  # The Jaro-Winkler similarity score in the third column, and
  # The fourth column indicates whether the match is an exact (absolute) or approximate (relative) match
  # The choice for which itemset to be base and which itemset to be used as reference is largely a preference

  base_series = sort(unique(base_series)) # filter only unique items from the vector
  reference_series = sort(unique(reference_series)) # and sort alphabetically 
  
  matches = as.data.frame(base_series)

  matches$matched = NA # create an empty column of matched base_series
  matches$similarity = NA
  for (i in 1:nrow(matches)){
    sim_scores = list()
    for (building_name in reference_series){
      sim_scores = append(sim_scores, jarowinkler(matches$base_series[i],building_name))
    } # loop through the longer column create a list of Jaro-Winkler similarity scores 
    matches$similarity[i] = max(unlist(sim_scores)) # return the highest similarity score
    matches$matched[i] = reference_series[which(sim_scores == max(unlist(sim_scores)))] 
    # take the item name corresponding to the highest similarity score
  }
  matches$absolute = ifelse(matches[,1] == matches$matched, TRUE, FALSE)
  return(matches)
}

###############
### Example ###
###############

# Initiate two datasets, each having a column with building names:
building = c("17 Seaver Street",
             "175 Wellesley Avenue",
             "189 Wellesley Avenue",
             "25 Burrill Lane",
             "37 Forest Street",
             "46 Burrill lane",
             "56 Whiting Road",
             "Alumni Hall",
             "Babson Executive Conf. Center",
             "Babson Hall",
             "Babson Skating Rink",
             "Blank Center",
             "Boston Sports Club",
             "Bryant Hall",
             "Campus",
             "Canfield Hall",
             "Central Services",
             "Coleman Chiller Plant",
             "Coleman Hall",
             "Forest Hall",
             "Forest Hall Annex",
             "Gerber Hall",
             "Glavin Chapel",
             "Hollister Building",
             "Horn Computer Center",
             "Horn Library",
             "Keith Hall",
             "Knight Auditorium",
             "Kriebel Hall",
             "Luksic Hall",
             "Malloy Hall",
             "Mandell Family Hall",
             "Mattos Hall",
             "McCullough Hall",
             "Millea Hall",
             "Mustard Hall",
             "Nichols Building",
             "Olin Hall",
             "Park Manor North",
             "Parking Deck",
             "Pietz Hall",
             "Post Office",
             "Public Safety Building",
             "Pump Station - Waste",
             "Putney Hall",
             "Reynolds Campus Center",
             "Sorenson Center for the Arts",
             "Sullivan Building",
             "Tomasso Hall",
             "Trim Hall",
             "Van Winkle Hall",
             "Webster Center",
             "Westgate Hall",
             "Woodland Hill 1",
             "Woodland Hill 10",
             "Woodland Hill 2",
             "Woodland Hill 2A",
             "Woodland Hill 3",
             "Woodland Hill 4",
             "Woodland Hill 5",
             "Woodland Hill 6",
             "Woodland Hill 7",
             "Woodland Hill 8",
             "Woodland Hill 9")
buildings = as.data.frame(cbind(building))

building_name = c(
  "17 Seaver Street",
  "175 Wellesley Avenue",
  "189 Wellesley Avenue",
  "25 Burrill Lane",
  "3 Burrill Lane",
  "37 Forest Street",
  "372 Washington Street",
  "46 Burrill Lane",
  "56 Whiting Road",
  "Alumni Hall",
  "Babson Commons",
  "Babson Executive Conference Center",
  "Babson Global (old)",
  "Babson Globe",
  "Babson Hall",
  "Babson Recreational Athletics Center",
  "Babson Skating Rink",
  "Baseball Press Box",
  "Blank Center",
  "Boston - 253 Summer St",
  "Boston Sports Club",
  "Boston Sports Club (Water Park)",
  "Bryant Hall",
  "Canfield Hall",
  "Central Services",
  "Coleman Chiller Plant",
  "Coleman Hall",
  "External Event",
  "Forest Hall",
  "Forest Hall Annex",
  "Gerber Hall",
  "Glavin Family Chapel",
  "Hollister Hall",
  "Horn Computer Center",
  "Horn Library",
  "Keith Hall",
  "Knight Auditorium",
  "Kriebel Hall",
  "Luksic Hall",
  "Malloy Hall",
  "Mandell Family Hall",
  "McCullough Hall",
  "Millea Hall",
  "Mustard Hall Lunder Admissions",
  "Nichols Hall",
  "Olin Hall",
  "Outdoor",
  "Outdoor-Zone Four",
  "Outdoor-Zone One",
  "Outdoor-Zone Three",
  "Outdoor-Zone Two",
  "Outdoor Field",
  "Park Manor Central",
  "Park Manor North",
  "Park Manor South",
  "Park Manor West",
  "Parking Deck",
  "Pietz Hall",
  "Post Office",
  "Public Safety",
  "Publishers Hall",
  "Pump Station (Sports Club)",
  "Putney Hall",
  "Reynolds Campus Center",
  "San Francisco Campus",
  "Service Garage",
  "Skating Rink - Snack Bar",
  "Softball Press Box",
  "Sorenson Theater (Center for Arts)",
  "Sullivan Building",
  "Tomasso Hall",
  "TrailerPool",
  "TrailerTurf",
  "Trim Hall",
  "Turf Field Press Box",
  "Universal Waste Facility",
  "Van Winkle Hall",
  "Webster Center",
  "Weissman Foundry",
  "Westgate Hall",
  "Wetlands",
  "Woodland Hills 1",
  "Woodland Hills 10",
  "Woodland Hills 2",
  "Woodland Hills 2A",
  "Woodland Hills 3",
  "Woodland Hills 4",
  "Woodland Hills 5",
  "Woodland Hills 6",
  "Woodland Hills 7",
  "Woodland Hills 8",
  "Woodland Hills 9",
  "Woodside",
  "X Dunkin Donuts") 
building_names = as.data.frame(building_name)

# Pass the vectors to the function:
matches = approxMatch(buildings$building, building_names$building_name)
View(matches)

# We can filter out the absolute match to get a table of relative matches to make decisions on which name to use for our "single truth."


