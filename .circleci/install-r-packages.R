update.packages(ask = FALSE, repos = 'http://cran.rstudio.org')
install.packages('knitr', repos = c('http://rforge.net', 'http://cran.rstudio.org'),
                 type = 'source')
install.packages('DBI', repos = c('http://rforge.net', 'http://cran.rstudio.org'),
                 type = 'source')
install.packages('RPostgres', repos = c('http://rforge.net', 'http://cran.rstudio.org'),
                 type = 'source')
