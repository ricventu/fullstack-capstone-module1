# Module 1 Solution - Core API Development and Deployment

## 1. Instantiate a Rails server application

* `$ rails-api new . -T -d postgresql`
* edit Gemfile
* `$ bundle`

## 2. Configure the application for use with a relational and MongoDB database

* edit config/database.yml
* `$ rake db:create`
* `$ rake db:migrate`

## 3. Provision (free) MongoDB databases for use in deployment

* create [mLab](https://mlab.com) MongoDB database
  * create db username and password

## 4. Provision (free) Heroku and PostgreSQL resources for use in deployment.

* create [Heroku](https://www.heroku.com) account

## 5. Deploy a branch of your application to production that displays information indicating the site is under construction

* `$ heroku create [appname] --remote production`
* `$ heroku git:remote -a <appname>-production`
* create git production branch
* `$ git push production production:master`

## 6. Deploy a branch of your application to staging

* `$ heroku create [appname] --remote staging`
* `$ heroku git:remote -a <appname>-staging`
* create git staging branch
* `$ git push staging staging:master`



## TODO

`$ rails g rspec:install`

