## Build the package -------------
## Now, build the `googletagmanagerv1.auto` package
# devtools::install_local("C:/Users/Manos/dev/R/autoGoogleAPI/googletagmanagerv1.auto")
# Package: googletagmanagerv1.auto
# Title: Tag Manager API
# Version: 0.0.0.9000
# Authors@R: c(person("Mark", "Edmondson",email = "m@sunholo.com",
#                     role = c("aut", "cre")))
# Description: Accesses Tag Manager accounts and containers. Auto-generated via
# googleAuthR.
# Depends: R (>= 3.3.1)
# License: MIT + file LICENSE
# Encoding: UTF-8
# LazyData: true
# Imports: googleAuthR (>= 0.3)
# RoxygenNote: 5.0.1
# Author: Mark Edmondson [aut, cre]
# Maintainer: Mark Edmondson <m@sunholo.com>
#   Built: R 3.3.1; ; 2016-09-13 10:48:03 UTC; windows
# RemoteType: local
# RemoteUrl: C:/Users/Manos/dev/R/autoGoogleAPI/googletagmanagerv1.auto
# RemoteSha: 0.0.0.9000

library(googleAuthR);
library(googletagmanagerv1.auto)

## Set the desired scopes for our problem(s)
options(googleAuthR.scopes.selected = c('https://www.googleapis.com/auth/tagmanager.delete.containers', 
                                        'https://www.googleapis.com/auth/tagmanager.edit.containers', 
                                        'https://www.googleapis.com/auth/tagmanager.edit.containerversions', 
                                        'https://www.googleapis.com/auth/tagmanager.manage.accounts', 
                                        'https://www.googleapis.com/auth/tagmanager.manage.users', 
                                        'https://www.googleapis.com/auth/tagmanager.publish', 
                                        'https://www.googleapis.com/auth/tagmanager.readonly'))

## Now authenticate to Google
gar_auth(new_user = TRUE)

## Get the accounts programmatically
accounts.gtm <- accounts.list()

## Sample Ids
accountId <- c(133845102,133845102,133845102) # 6018606,6018606,6018606,
containerId <- c(1643210,1834331,1833826) # 568174,577022,756110,

## Define functions for the `googletagmanagerv1` package
## but let's use them directly here
tags.list <- function(accountId,containerId) {
  url <- paste0("https://www.googleapis.com/tagmanager/v1/accounts/",accountId,"/containers/",containerId,"/tags")
  # tagmanager.tags.list
  f <- gar_api_generator(url, "GET", data_parse_function = function(x) x)
  f()
}

account_versions.list <- function(accountId,containerId) {
  url <- paste0("https://www.googleapis.com/tagmanager/v1/accounts/",accountId,"/containers/",containerId,"/versions?headers=true&includeDeleted=false&fields=containerVersion(name%2Cnotes)%2CcontainerVersionHeader")
  # tagmanager.tags.list
  f <- gar_api_generator(url, "GET", data_parse_function = function(x) x)
  f()
}
                         
containers.list <- function(accountId) {
  url <- paste0("https://www.googleapis.com/tagmanager/v1/accounts/",accountId,"/containers/")
  # tagmanager.tags.list
  f <- gar_api_generator(url, "GET", data_parse_function = function(x) x)
  f()
}


triggers.list <- function(accountId,containerId) {
  url <- paste0("https://www.googleapis.com/tagmanager/v1/accounts/",accountId,"/containers/",containerId,"/triggers")
  # tagmanager.triggers.list
  f <- gar_api_generator(url, "GET", data_parse_function = function(x) x)
  f()
}


variables.list <- function(accountId,containerId) {
  url <- paste0("https://www.googleapis.com/tagmanager/v1/accounts/",accountId,"/containers/",containerId,"/variables")
  # tagmanager.variables.list
  f <- gar_api_generator(url, "GET", data_parse_function = function(x) x)
  f()
}

time <- 3;
for (acc_Id in accountId){
  for (con_Id in containerId) {
    container.tags <- tags.list(acc_Id,con_Id)
    container.triggers <- triggers.list(acc_Id,con_Id)
    container.variables <- variables.list(acc_Id,con_Id)
    
    ## Parameter is a `JSON` (so in `R` this is a `list`), that we will not use for now
    # str(container.tags$tags$parameter)
    
    ## Objects of interest
    tags <- container.tags$tags
    triggers <- container.triggers$triggers
    variables <- container.variables$variables
    
    ## Push it to a Google Sheet
    # require(googlesheets)
    
    ## Auth with `googlesheets`
    # gs_auth()
    
    ## Register a new Google Sheet to pass the data
    gs_new(paste("(Auto) GTM Implementation - ",acc_Id,"_",con_Id), verbose = TRUE)
    s_id <- gs_title(paste("(Auto) GTM Implementation - ",acc_Id,"_", con_Id), verbose = TRUE)
    # gs_ws_new(ss=s_id, ws_title = "Tags")
    # gs_ws_new(ss=s_id, ws_title = "Triggers")
    # gs_ws_new(ss=s_id, ws_title = "Variables")
    yo.tags <- gs_ws_new(ss=s_id, ws_title="Tags" , input = tags[,1:10], trim = TRUE)
    yo.triggers <- gs_ws_new(ss=s_id, ws_title="Triggers", input = triggers, trim = TRUE)
    yo.variables <- gs_ws_new(ss=s_id, ws_title="Variables", input = variables, trim = TRUE)
    
    ## Share the spreadsheet via an email
    # require(mailR)
    # s_id$browser_url)
    
  }
  Sys.sleep(time) # This is used to cool off the API calls...
}

# 
# msg <- paste(s_id$browser_url)
# sender <- "parzakonis.m@gmail.com"  # Replace with a valid address
# recipients <- c("manos@statsravingmad.com")  # Replace with one or more valid addresses
# email <- send.mail(from = sender,
#                    to = recipients,
#                    subject="Subject of the email",
#                    body = "Body of the email",
#                    smtp = list(host.name = "smtp.gmail.com", port = 465,user.name = "manos parzakonis",
#                                passwd = "qzvxxthfdwnlmjwm", ssl = TRUE),
#                    authenticate = TRUE,
#                    send = TRUE)
