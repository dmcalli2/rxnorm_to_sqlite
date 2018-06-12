# 02_examine_rxnorm
library(RSQLite)
library(tidyverse)
# Create connection
con <- dbConnect(SQLite(), "rxnorm.sqlite")

# Read tables
tablename <- dbListTables(con)

# Examine head of tables
head_each_table <- vector(length = length(tablename), mode = "list")
names(head_each_table) <- tablename

for (i in tablename) {
  head_each_table [[i]]  <- dbGetQuery(con, paste0("SELECT * FROM ", i, " LIMIT 6"))
}

atc <- dbGetQuery(con, "SELECT * FROM RXNCONSO WHERE SAB == 'ATC' ")
save(atc, file = "atc.Rdata")


