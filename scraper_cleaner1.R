library("rvest")

#where you are scraping
link = "https://finance.yahoo.com/markets/stocks/most-active/"

#scrape all of the html content for the provided url
htmlcontent <- read_html(link)
print(htmlcontent)

#ask for the html for the table contents
table_node <- html_nodes(htmlcontent, "table")
table_node

#pull the contents of the table into a tibble
table_content <- html_table(table_node)[[1]]

table_content

#rename the column named ""
names(table_content)[3] = "empty"

#check columns not printed
table_content[9:12]

#remove empty columns
table_content2 <- select (table_content, -c('empty', '52 Wk Range'))

#make tibble a data frame
df <- data.frame(table_content2)
df

#alter price column
#remove the extra information given in the price column
df[,3] <- gsub("\\0.0000.*", "\\1", df[,3])
##remove the second instance of 0.0000 and beyond
df[,3] <- gsub("\\+.*", "", df[,3])
df[,3] <- gsub("\\-.*", "", df[,3])
##remove positives and negatives and beyond
df[,3]
df[,3] <- as.numeric(df[,3])
##make the price column numeric


#Change column
df[,4] <- as.numeric(df[,4])

#Change % column
df[,5] <- sub("\\+", "", df[,5])
##remove all '+', keep '-' for negative values
df[,5] <- sub("\\%", "", df[,5])
##remove % signs
df[,5] <- as.numeric(df[,5])
df[,5] <- df[,5]*.01
##change % into decimal point equivalent
df[,5]

#Volume
df[,6] <- gsub("M", "000", df[,6])
df[,6] <- gsub("B", "000000", df[,6])
df[,6] <- gsub("T", "000000000", df[,6])
##remove and replace M, B, T with the correct number of 0s
df[,6] <- gsub("\\.", "", df[,6])
##remove "."
df[,6] <- as.numeric(df[,6])
##make the price column numeric
df[,6]

#Avg Vol (3M)
df[,7] <- gsub("M", "000", df[,7])
df[,7] <- gsub("B", "000000", df[,7])
df[,7] <- gsub("T", "000000000", df[,7])
##remove and replace M, B, T with the correct number of 0s
df[,7] <- gsub("\\.", "", df[,7])
##remove "."
df[,7] <- as.numeric(df[,7])
##make the price column numeric
df[,7]

#Market Cap
df[,8] <- gsub("M", "000", df[,8])
df[,8] <- gsub("B", "000000", df[,8])
df[,8] <- gsub("T", "000000000", df[,8])
##Remove and replace M, B, T with the correct number of 0s
df[,8] <- gsub("\\.", "", df[,8])
##remove "."
df[,8] <- as.numeric(df[,8])
##make the price column numeric
df[,8]

#P/E Ratio (TTM)
df[,9] <- sub("\\-", "0", df[,9])
##remove all "-" rows and replace them with 0s
###this is because the - rows were 0 or negative and not 
###able to be calculated.  Keep this in mind for calculations
df[,9] <- as.numeric(df[,9])
##make column numeric
df[,9]

#52 Wk Change %
df[,10] <- sub("\\%", "", df[,10])
##remove % signs
df[,10] <- sub("\\,", "", df[,10])
##remove potential ','
df[,10] <- as.numeric(df[,10])
##change to numeric
df[,10] <- df[,10]*0.01
##change percent value to decimal format
df[,10]

library("dplyr")
select_if(df, is.numeric)

most_active_stocks <- df
most_active_stocks



write_csv(most_active_stocks, "C:.../most_active_stocks.csv")
