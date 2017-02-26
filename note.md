# Module 1 Solution - Core API Development and Deployment

## 1. Instantiate a Rails server application

* `$ rails-api new . -T -d postgresql`
* edit Gemfile
* `$ bundle`
* `$ rails g rspec:install`

## 2. Configure the application for use with a relational and MongoDB database

* edit config/database.yml
* `$ rake db:create`
* `$ rake db:migrate`

* edit Gemfile

```Gemfile
gem 'pg', '~>0.19', '>=0.19.0'
gem 'puma', '~>3.6', '>=3.6.0', :platforms=>:ruby
gem 'mongoid', '~>5.1', '>=5.1.5'
```

* `$ bundle`
* `$ rails g mongoid:config`
* edit config/mongoid.yml
* edit config/application.rb

```ruby
Mongoid.load!('./config/mongoid.yml')
#which default ORM are we using with scaffold
#add  --orm mongoid, or active_record 
#    to rails generate cmd line to be specific
config.generators {|g| g.orm :active_record}
#config.generators {|g| g.orm :mongoid}
```

## 3. Provision (free) MongoDB databases for use in deployment

* create [mLab](https://mlab.com) MongoDB database
  * create db username and password

* `rails g scaffold Bar name --orm mongoid --no-request-specs --no-routing-specs --no-controller-specs`
* `rm spec/models/bar_spec.rb`

## 4. Provision (free) Heroku and PostgreSQL resources for use in deployment.

* create [Heroku](https://www.heroku.com) account

## 5. Deploy a branch of your application to production that displays information indicating the site is under construction

* `$ heroku create [appname] --remote production`
* `$ heroku git:remote -a <appname>-production`
* create git production branch
* create `Procfile` to run Puma web server
* `$ rails g controller ui`
* `$ rm spec/controllers/ui_controller_spec.rb`
* `$ mkdir -p app/views/ui`
* `$ echo "Capstone Site Under Construction -- check back soon" > app/views/ui/index.html.erb`
* make the connection between controller action and associated view
  app/controllers/application_controller.rb:

```ruby
class ApplicationController < ActionController::API
  #make the connection between controller action and associated view
  include ActionController::ImplicitRender
end
```

* add default route in config/routes.rb:

```ruby
  get '/ui'  => 'ui#index'
  get '/ui#' => 'ui#index'
  root "ui#index"
```

* `$ git push production production:master`

## 6. Deploy a branch of your application to staging

* `$ heroku create [appname] --remote staging`
* `$ heroku git:remote -a <appname>-staging`
* create git staging branch
* `$ git push staging staging:master`


## 7. (30 min) Implement an end-to-end thread from the API to the relational database for a resource called Cities

## TODO



