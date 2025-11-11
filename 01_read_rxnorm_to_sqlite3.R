#01 create database in RSQLITE
library(RSQLite)
library(readr)

## Funtions to read database
# read in sql-statements and preformat them                                        
sqlFromFile <- function(file){
  require(stringr)
  sql <- readLines(file)
  sql <- unlist(str_split(paste(sql,collapse=" "),";"))
  sql <- sql[grep("^ *$", sql, invert=T)]
  sql
}

# apply query function to each element
dbSendQueries <- function(con,sql){
  dummyfunction <- function(sql,con){
    dbSendQuery(con,sql)
  }
  lapply(sql, dummyfunction, con)
}

# Create connection
con <- dbConnect(SQLite(), "rxnorm.sqlite")

# Run script via rsqlite
sql_scripts <- sqlFromFile("Table_scripts_mysql_rxn.sql") 
dbSendQueries( con, sql_scripts )

tablename <- dbListTables(con)
table_fields <- vector(length = length(tablename), mode = "list")
names(table_fields) <- tablename
for (i in tablename) {
  table_fields [[i]]  <- dbListFields(con, i)
}
table_fields_count <- sapply(table_fields, length)

## read in all dataframes
## and write dataframes to RSQLITE
zipfilename <- "RxNorm_full_10062025.zip"
for (i in 1:length(tablename)){
  print(tablename[i])
  print(paste0(table_fields_count[i], " columns"))
  # Need to read empty column as ends ina  pipe
  mydf <- read_delim (unz(zipfilename, paste0("rrf/", tablename[i], ".RRF")), delim = "|",
                      col_names = FALSE,
                      col_types = paste(c(rep("c", table_fields_count[i]), "_"), collapse = ""))
  mydf <- as.data.frame(mydf)
  names(mydf) <- table_fields[[i]]
  dbWriteTable(con, name = tablename[i], value = mydf, append = TRUE)
  rm(mydf)
}

# Run script to add indices
# dbSendQueries(con, sqlFromFile("Indexes_mysql_rxn.sql") )
dbSendQueries(con, sqlFromFile(unz(zipfilename, "scripts/mysql/Indexes_mysql_rxn.sql")) )
dbGetQuery(con, "SELECT * FROM sqlite_master WHERE type = 'index'")
dbDisconnect(con)

