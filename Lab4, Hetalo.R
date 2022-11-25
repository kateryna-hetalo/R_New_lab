#install.packages
install.packages("DBI")
install.packages("odbc")
install.packages("RSQLite")
library(odbc)

#database connection
db_path <- "E:\\KNU\\R\\database.sqlite"
conn <- dbConnect(RSQLite::SQLite(), db_path)
# check tables in a database
dbListTables(conn)
df_names <- dbSendQuery(conn, "SELECT Name as Author FROM Authors ORDER BY Name")
df <- dbFetch(df_names, n=10)
df

# 1 select spotlight records
data_spotlight <- dbSendQuery(conn, "SELECT Title, EventType FROM Papers WHERE EventType='Spotlight' ORDER BY Title")
dbFetch(data_spotlight , n=10)

# 2 select records with Josh Tenenbaum as author
data_josh <- dbSendQuery(conn, "SELECT Name, Title 
                                FROM Authors as x inner join PaperAuthors as y on x.id=y.Authorid
                                inner join Papers as z on z.id=y.Paperid  
                                WHERE Name='Josh Tenenbaum'
                                ORDER BY Title")
dbFetch(data_josh , n=10)


# 3 select records with 'statistical' in Title
data_stat <- dbSendQuery(conn, "SELECT Title
                                 FROM Papers 
                                 WHERE Title LIKE '%statistical%' 
                                 ORDER BY Title")

dbFetch(data_stat , n=10)

# 4 count papers for each author
data_num <- dbSendQuery(conn, "SELECT Name, COUNT (Title) AS NumPapers
                               FROM Authors as x
                               INNER JOIN PaperAuthors as y ON x.Id = y.AuthorID 
                               INNER JOIN Papers as z ON y.PaperId = z.Id
                               GROUP BY Name
                               ORDER BY NumPapers DESC")
dbFetch(data_num, n=10)
