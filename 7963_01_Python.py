import pandas as pd
import numpy as np

# Create the required data frames by reading in the files
df_s = pd.read_excel('SaleData.xlsx')
df_i = pd.read_csv('imdb.csv',escapechar = "\\")
df_m = pd.read_csv('movie_metadata.csv')
df_d = pd.read_csv('diamonds.csv')


# Q1 Find least sales amount for each item
# has been solved as an example
def least_sales(df):
	ls = df.groupby(["Item"])["Sale_amt"].min().reset_index()
	return ls

# Q2 compute total sales at each year X region
def sales_year_region(df):
	df['year'] = df['OrderDate'].dt.year
	syr = df.groupby(['year','Region'])['Sale_amt'].sum().reset_index()
	return syr

# Q3 append column with no of days difference from present date to each order date
from datetime import date
def days_diff(df):
	df['days_diff'] = pd.to_datetime(date.today()) - df['OrderDate']
	return df

# Q4 get dataframe with manager as first column and  salesman under them as lists in rows in second column.
def mgr_slsmn(df):
	ms = df.groupby('Manager')['SalesMan'].apply(lambda x: ','.join(set(x.dropna()))).rename('list_of_salesman').reset_index()
	return ms

# Q5 For all regions find number of salesman and number of units
def slsmn_units(df):
	df1 = df.groupby(['Region'])['SalesMan'].count().rename('salesmen_count')
	df2 = df.groupby(['Region'])['Sale_amt'].sum().rename('total_sales')
	ls = pd.concat([df1,df2],axis=1)
	return ls

# Q6 Find total sales as percentage for each manager
def sales_pct(df):
	total_sales = df.groupby(['Manager'])['Sale_amt'].sum().rename('total_sales')
	sum1 = total_sales.sum()
	ps = total_sales.apply(lambda x: x/sum1).rename('percent_sales').reset_index()
	return ps

# Q7 get imdb rating for fifth movie of dataframe
def fifth_movie(df):
	ls = df.loc[4,'imdb_score']
	return ls

# Q8 return titles of movies with shortest and longest run time
def movies(df):
	title = []
	title.append(df[df['duration'] == df['duration'].max()]['movie_title'].values)
	title.append(df[df['duration'] == df['duration'].min()]['movie_title'].values)
	return title

# Q9 sort by two columns - release_date (earliest) and Imdb rating(highest to lowest)
def sort_df(df):
	ls = df.sort_values(['title_year', 'imdb_score'], ascending=[True, False])
	return ls

# Q10 subset revenue more than 2 million and spent less than 1 million & duration between 30 mintues to 180 minutes
def subset_df(df):
	ls = df[(df['gross'] > 2000000) & (df['budget'] < 1000000) & (df['duration'] >= 30) & (df['duration'] <= 180)]
	return ls

# Q11 count the duplicate rows of diamonds DataFrame.
def dupl_rows(df):
	ls = df.duplicated().sum()
	return ls

# Q12 droping those rows where any value in a row is missing in carat and cut columns
def drop_row(df):
	ls = df.dropna(subset=['carat','cut'],how='any')
	return ls

# Q13 subset only numeric columns
def sub_numeric(df):
	ls = df.select_dtypes(include=np.number)
	return ls

# Q14 compute volume as (x*y*z) when depth > 60 else 8
def vol(df):
    vol = []
    for i in range(len(df)):
        if(df['depth'][i] > 60):
            if(df['z'][i] == 'None'):
                vol.append(np.nan)
            else:
                vol.append(float(df['x'][i])*float(df['y'][i])*float(df['z'][i]))
        else:
            vol.append(8)
    df['volume'] = vol
    return df

# Q15 impute missing price values with mean
def impute(df):
	#df['price'].fillna(value=df['price'].mean(),inplace = True) //for change in dataframe
	ls = df['price'].fillna(value=df['price'].mean())
	return ls

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

def bonus_1(df):
    df['Genre_combo'] = df[df.columns[16:]].T.apply(lambda x : "|".join(x.index[x==1]),axis=0)
    df=df.groupby(["type","year","Genre_combo"]).agg(avg_rating = ("imdbRating","mean"),
                                                  min_rating = ("imdbRating","min"),
                                                  max_rating = ("imdbRating","max"),
                                                  total_run_time_mins = ("duration",np.sum))
    return df

def bonus_2(df):
    #Relation
    df['length'].corr(df['imdbRating'])
    #Quantiles
    df['Quantile']=pd.qcut(df['length'], 4, labels=False)
    df2=pd.crosstab(df.year,df.Quantile).rename(columns={0:"num_videos_less_than25Percentile",
                                                         1:"num_videos_25_50Percentile",
                                                         2:"num_videos_50_75Percentile",
                                                         3:"num_videos_greaterthan75Precentile"})
    df2['min_length'] = df.groupby(["year"])["length"].min()
    df2['max_length'] = df.groupby(["year"])["length"].max()
    return df2

def bonus_3(df):
    df['bins'] = pd.qcut(df['volume'],4)
    df2 = pd.crosstab(df.bins,df.cut).apply(lambda r: r/r.sum(), axis=1)
    return df2

def bonus_4(df):
    df.groupby(['year'])['imdbRating'].mean()

def bonus_5(df):
    df['bins'] = pd.qcut(df['duration'],10)
    df2 = df.groupby(['bins']).agg(nominations = ("nrOfNominations","sum"),
                               wins = ("nrOfWins","sum"))
    return df2


