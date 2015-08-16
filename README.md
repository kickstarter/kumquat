# Kumquat

Kumquat is a reporting tool for rendering RMarkdown files inside Rails.

For example, call RMarkdown as partials:

`render '_a_knitr_report'`

Which calls `_a_knitr_report.Rmd`:

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

Kumquat can be integrated anywhere inside Rails, but in particular emails.

# How it Works


# Setup & Development

## Chef Recipe
* [Chef recipe](https://github.com/kickstarter/kumquat/wiki/Suggested-Chef-Recipe)

## R Dependencies
* knitr
* RPostgres

## Sending emails from a local development environment

* `X-KUMQUAT`

* To enable mailer errors in your development environment comment out:
  * `config.action_mailer.raise_delivery_errors = false`
  * `config.action_mailer.delivery_method = :test`
* In terminal, run the command `sudo postfix start`

## Logging

* You can view kumquat and email logs for debugging:
  - `tail -f log/kumquat.log`
