# rxnorm_to_sqlite

This short bit of R code runs SQL code, which has been provided by the US National Library of Medicine, in order to create an [SQLITE database](https://www.sqlite.org/index.html). The NLM SQL code reads [RXNORM](https://www.nlm.nih.gov/research/umls/rxnorm/) Rich Release Format (RRF) text files into a database, also creating a number of suitable indexes. The NLM SQL code was written for reading the database into MYSQL, but needed only one small change (removing a single contraint) to run in SQLITE. This has only been tested in three releases of RXNORM, 2016-01-08  2018-06-12 and 2025-10-6 (filename RxNorm_full_10062025).

This approach does not read in the database perfectly (the readr::read_delim function gives a warning about some of the files), but is a quick and easy way to quickly read RXNORM into an R-accessible format without having to install a large complex server SQL database engine such as MYSQL.

This code reuses, with permission, some code written by [Peter Meissener on stackoverflow](http://stackoverflow.com/questions/18914283/how-to-execute-more-than-one-rsqlite-statement-at-once-or-how-to-dump-a-whole-fi/18953423)
