# Approximate String Matching in R using Jaro-Winkler similarity
This project proposes a function to create a table with matching strings from two data vectors using Jaro-Winkler similarity method.

## Mathematical method in string similarity
### Levenshtein:
Levenshtein distance counts the number of characters that need editing for two strings to match. Levenshtein similarity turns this distance to a percentage score from 0 to 1. However, Levenshtein does not take into account the order in which the characters match between two strings. 
#### To calculate Levenshtein distance in R:
library(RecordLinkage)
levenshteinDist(string_a, string_b)
#### To calculate Levenshtein similarity in R:
library(RecordLinkage)
levenshteinSim(string_a, string_b)

### Jaro-Winkler
In languages like English, the name, characteristic, or otherwise distinctive information of a phrase is often placed in the beginning not the end (e.g., "tiger skin" not "skin tiger"). Therefore, we need a method that gives more weight to the matches in the first few characters (i.e., the _prefix_). That method is Jaro-Winkler similarity.

#### To calculate Jaro-Winkler similarity in R:
library(RecordLinkage)
jarowinkler(string_a, string_b)

Note that the defaults of jarowinkler() are:
- p (additional Winkler weight given to matches in the prefix): 0.1
- _l_ (length of prefix to be given weight): first 4 characters
- threshold (Jaro similarity score above which Winkler adjustment is applied and below which Jaro similarity score is returned): 0.7

## About the function in this project:
User can copy the function and simply pass the two vectors that contain items for comparison. For example, if the user has dataset1 and dataset2, each having an "item" column, they can:
matchTable = approxMatch(dataset1$item, dataset2$item)
View(matchTable)
The function will remove duplicates and sort alphabetically for both vectors and return a table with:
- Items from dataset1 as the basis column, 
- The second column containing items from the reference vector that are most likely to match with those in the base vector,
- The third column giving the highest possible Jaro-Winkler similarity scores, and
- The fourth column indicating whether the match is an exact (absolute) or approximate (relative) match. 
This helps in making edit decisions to match strings from two column.
