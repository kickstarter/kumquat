# Kumquat

Kumquat is a reporting tool for sending RMarkdown files over email.


For example, call RMarkdown as partials:

`render 'live_projects'`

Which calls _live_project_graphs.Rmd:


```r
A Test Report for Kumquat
========================================================

This is some code for Knitr, including [a link](https://www.kickstarter.com).

A list:

* One
* Another thing
* Last thing!

### More stuff.

Lorem Ipsum.

```{r, fig.width=10, fig.height=8, echo=FALSE, message=FALSE}
library(ggplot2)
qplot(data = data.frame( x = runif(100), y = runif(100) ), x = x, y = y)
```

The great part about this is that it can be integrated anywhere inside Rails, but in particular emails.

_TODO_
* Tests
* Make Redshift optional
* Documentation:
    * Mail Interceptor
    * Redshift
    * Chef Recipe
