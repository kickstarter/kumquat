# Kumquat

Kumquat is a reporting tool for rendering [RMarkdown](http://kbroman.org/knitr_knutshell/pages/Rmarkdown.html) files inside Rails.

RMarkdown, or `.Rmd` files are Markdown files with code chunks of [R](http://r-project.org/) in them.

You can use Kumquat to integerate R output into Rails, which is useful for using libaries like `ggplot2` in email reporting tools.

# Example

For example, consider a typical `render` call to a partial:

`render '_a_knitr_report'`

This partial is `_a_knitr_report.Rmd`, a regular RMarkdown file stored in your app:

```md
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
```

Which yields the following output:

![Kumquat Screenshot](https://ksr-ugc.imgix.net/assets/003/462/965/08a6aecce8d70673600920f20b80260e_original.png?v=1426711514&w=700&fit=max&auto=format&lossless=true&s=a5d29734ce223f8797f896614e46398e "Kumquat in Action")

Kumquat can be integrated anywhere inside Rails views where partials are called.

# How it Works

Kumquat requires R to be installed on the machines running your application. The main action is then in `Knit2HTML` which shells out to `Rscript` and runs the necessary `knitr` package methods to compile HTML.

When you install Kumquat a template handler is registered to handle Rmd files.

# Also, Email

A mail interceptor, `KumquatReportInterceptor` is also registered to attach images inline to Rmd reports marked with an `X-KUMQUAT` signature which you can add to a mail object accordingly:

```ruby
    mail :to => @admin.email,
      :reply_to => "dev@kickstarter.com",
      :subject => "Test Kumquat Report",
      'X-KUMQUAT' => true do |format|
        format.text { render layout: nil }
        format.html { render layout: nil }
    end
```

# Setup & Development

Kumquat requires R to be installed, and the knitr packages to render RMarkdown files. The rest of the R dependencies are up to you, but need to be specified in the `KNITR_LIBRARIES` constant in the `Knit2HTML` class.

## Chef Recipe
If you're curious about installing R using Chef, check out [a suggested recipe on the wiki](https://github.com/kickstarter/kumquat/wiki/Suggested-Chef-Recipe)

## Database Support
If you need to connect R to a database and provide credentials from your application, you can do so in an application initializer like so:

```ruby
Kumquat.database_config(Configs[:redshift].merge({ database_connector: "RPostgres::Postgres()" }))
```

We are using Hadley Wickham's [RPostgres library](https://github.com/rstats-db/RPostgres) which can be installed in R accordingly:

```R
install.packages("devtools")
devtools::install_github("RcppCore/Rcpp")
devtools::install_github("rstats-db/DBI")
devtools::install_github("rstats-db/RPostgres")

library(DBI)
```

## Sending emails from a local development environment

If you'd like to deliver emails in your local environment, make sure your `config.action_mailer.delivery_method` is configured properly, and you have a way to send email locally (on OS X, run the command `sudo postfix start`).

## Logging
You can view kumquat and email logs for debugging `tail -f log/kumquat.log`
