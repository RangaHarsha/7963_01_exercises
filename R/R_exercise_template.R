library(readxl)
library(dplyr)
library(lubridate)

#Reading diamond.csv
df_d <- read.csv('diamonds.csv')
#Reading IMDB.csv
df_i <- read.csv('imdb.csv')
#Reading SalesData
excel_sheets('SaleData.xlsx')
df_s <- read_excel('SaleData.xlsx',sheet = 'Sales Data')

#print(head(df_s))
#print(head(df_i))
#print(head(df_d))

# Q1 Find least sales amount for each item
least_sales <- function(df){
  ls <- df %>% group_by(Item) %>% summarise(least_sales = min(Sale_amt,na.rm = TRUE))
  return(ls)
}

# Q2 compute total sales at each year X region
sales_year_region <- function(df){
  dn <- mutate(df,year = as.numeric(format(OrderDate,'%Y')))
  ts <- dn %>% group_by(year,Region) %>% summarise( total_sales = sum(Sale_amt,na.rm = TRUE))
  return(ts)
  
}

# Q3 append column with no of days difference from present date to each order date
days_diff <- function(df){
  res <- mutate(df,days_diff = abs(Sys.Date() - as.Date(OrderDate)))
  return(res)
  
}

# Q4 get dataframe with manager as first column and  salesman under them as lists in rows in second column.
mgr_slsmn <- function(df){
  un <- select(df,Manager,SalesMan)
  dt <- unique(un)
  agg <- aggregate(dt$SalesMan, list(dt$Manager), paste, collapse=",")
  agg <- rename(agg,Manager=Group.1,list_of_salesmen=x)
  return(agg)
}
    
# Q5 For all regions find number of salesman and number of units
slsmn_units <- function(df){
  df2 <- df %>% group_by(Region) %>% summarise(total_sales = sum(Sale_amt,na.rm = TRUE))
  df1 <- df %>% group_by(Region) %>% count(SalesMan) %>% select(Region,n) %>% summarise(salesmen_count = sum(n))
  res <- merge(df1,df2)
  return(res)
}
    
# Q6 Find total sales as percentage for each manager
sales_pct <- function(df){
  tot <- df %>% group_by(Manager) %>% summarise(total_sales = sum(Sale_amt,na.rm = TRUE))
  tot <- select(mutate(tot,percent_sales = total_sales/sum(total_sales)),Manager,percent_sales)
  return(tot)
}
  
# Q7 get imdb rating for fifth movie of dataframe
fifth_movie <- function(df){
  res <- df[5,] %>% select(imdbRating)
  return(res)
  
}

# Q8 return titles of movies with shortest and longest run time
movies <- function(df){
  tit <- df %>% filter(duration == max(as.numeric(as.character(df$duration)),na.rm = TRUE)) %>% select(movie_title)
  rbind(tit,df %>% filter(duration == min(as.numeric(as.character(df$duration)),na.rm = TRUE)) %>% select(movie_title))
  return(tit)
}

# Q9 sort by two columns - release_date (earliest) and Imdb rating(highest to lowest)
sort_df <- function(df){
  sd <- arrange(df,year,desc(imdbRating))
  return(sd)
  
}

# Q10 subset revenue more than 2 million and spent less than 1 million & duration between 30 mintues to 180 minutes
subset_df <- function(df){
  sd <- filter(df,gross > 2000000,budget < 1000000,duration >= 30,duration <= 180)
  return(sd)
  
}

#Q11 count the duplicate rows of diamonds DataFrame.
dupl_rows <- function(df){
  dup <- sum(duplicated(df))
  return(dup)
  
}

#Q12 droping those rows where any value in a row is missing in carat and cut columns
drop_row <- function(df){
  dr <- na.omit(df, cols=c("carat", "cut"))
  return(dr)
  
}

# Q13 subset only numeric columns
sub_numeric <- function(df){
  num <- select_if(df,is.numeric)
  return(num)
}

# Q14 compute volume as (x*y*z) when depth > 60 else 8
volume <- function(df){
  df$volume <- ifelse(df$depth > 60,((as.numeric(as.character(df$x))) * (as.numeric(as.character(df$y))) * (as.numeric(as.character(df$z)))),8)
  return(df)
  
}

#Q15 impute missing price values with mean
impute <- function(df){
  imp <- mutate(df,price=ifelse(is.na(price),mean(price, na.rm = TRUE),price))
  return(imp)
  
}
#print(least_sales(df_s))
#print(sales_year_region(df_s))
#print(days_diff(df_s))
#print(mgr_slsmn(df_s))
#print(slsmn_units(df_s))
#print(sales_pct(df_s))
#print(fifth_movie(df_i))
#print(movies(df_i))
#print(sort_df(df_i))
#print(subset_df(df_i))
#print(dupl_rows(df_d))
#print(drop_row(df_d))
#print(sub_numeric(df_d))
#print(volume(df_d))
#print(impute(df_d))
