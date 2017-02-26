# Module 1 Solution - Core API Development and Deployment

## 1. Instantiate a Rails server application

* `$ rails-api new . -T -d postgresql`

## 2. Configure the application for use with a relational and MongoDB database

* edit Gemfile

```Gemfile
gem 'pg', '~>0.19', '>=0.19.0'
gem 'puma', '~>3.6', '>=3.6.0', :platforms=>:ruby
gem 'mongoid', '~>5.1', '>=5.1.5'
```

* `$ bundle`

* edit config/database.yml
* `$ rake db:create`

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

### RSPEC

* `$ rails g rspec:install`
* `$ rails g rspec:request APIDevelopment`
* .rspec:

```text
--color
--require spec_helper
--format documentation
--no-fail-fast
```

* `$ rake`


#### RDBMS

* `$ rails-api g scaffold Foo name --orm active_record --no-request-specs --no-routing-specs --no-controller-specs`
* `$ rm spec/models/foo_spec.rb`
* `$ rake db:migrate`
* make the connection between controller action and associated view in
  app/controllers/application_controller.rb:

```ruby
class ApplicationController < ActionController::API
  #make the connection between controller action and associated view
  include ActionController::ImplicitRender
end
```

* add default route in config/routes.rb with scope */api*:

```ruby
scope :api, defaults: {format: :json}  do
  resources :foos, except: [:new, :edit]
end
```

* Unfortunately when the controller was generated, it didn't take into account
  that the view was there. And so, you see how it's explicitly calling render on
  an object instead of render on a particular view type? So, what we want to do
  is comment this out, because if we left it in, it would just be explicitly
  calling to JSON on the object, and not passing to the view. Which we would
  lose our chance to control how that's going to get marshaled. We want to be
  able to do that on the first couple of methods.
  foos_controller:

```ruby
  def index
    @foos = Foo.all
    # render json: @foos
  end

  def show
    # render json: @foo
  end

  def create
    @foo = Foo.new(foo_params)

    if @foo.save
      #render json: @foo, status: :created, location: @foo
      render :show, status: :created, location: @foo
    else
      render json: @foo.errors, status: :unprocessable_entity
  end
```

* `$ rspec -e RDBMS -fd`

#### MongoDB

* `$ rails g scaffold Bar name --orm mongoid --no-request-specs --no-routing-specs --no-controller-specs`
* `$ rm spec/models/bar_spec.rb`
* edit models/bar.rb to include `create_at` and `updated_at`, non include by default in MongoDB

```ruby
class Bar
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
end
```

* add default route in config/routes.rb with scope */api*:

```ruby
scope :api, defaults: {format: :json}  do
  resources :foos, except: [:new, :edit]
  resources :bars, except: [:new, :edit]
end
```

* in the controller delegate jbuilder for the view
* to view mongoid id ad string, fix the _bar.json.jbuilder

```ruby
#json.extract! bar, :id, :name, :created_at, :updated_at
json.id bar.id.to_s
json.name bar.name
json.created_at bar.created_at
json.updated_at bar.updated_at
json.url bar_url(bar, format: :json)
```

* `$ rspec -e MongoDB -fd`

## 3. Provision (free) MongoDB databases for use in deployment

* create [mLab](https://mlab.com) MongoDB database
  * create db username and password

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

* The resource will have an id:integer (default) and name:string property
* The resource name must be accessable via the /api/cities URI
* The resource must be backed by a RDBMS using ActiveRecord
* The resource will be deployed with a city with the name Baltimore



