# Module 1 Solution - Core API Development and Deployment

## 1. Instantiate a Rails server application

* `$ rails-api new . -T -d postgresql`

## 2. Configure the application for use with a relational and MongoDB database

* edit Gemfile
* `$ bundle`
* edit config/database.yml
* `$ rake db:create`
* edit config/mongoid.yml
* `$ rails g mongoid:config`

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

## 3. Provision (free) MongoDB databases for use in deployment

* create [mLab](https://mlab.com) MongoDB database
* create db username and password

## 4. Provision (free) Heroku and PostgreSQL resources for use in deployment.

* create [Heroku](https://www.heroku.com) account
* add MLAB_URI var to Heroku with url of mLab database

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

* `heroku run rake --trace db:migrate --remote production`
* `$ git push production production:master`

## 6. Deploy a branch of your application to staging

* `$ heroku create [appname] --remote staging`
* `$ heroku git:remote -a <appname>-staging`
* create git staging branch
* `heroku run rake --trace db:migrate --remote staging`
* `$ git push staging staging:master`

## 7. Implement an end-to-end thread from the API to the relational database for a resource called Cities

* The resource will have an id:integer (default) and name:string property
* The resource name must be accessable via the /api/cities URI
* The resource must be backed by a RDBMS using ActiveRecord
* The resource will be deployed with a city with the name Baltimore
* A client performing a GET of of the /api/cities resource must at least get one city with name Baltimore

* `$ rails-api g scaffold City name --orm active_record --no-request-specs --no-routing-specs --no-controller-specs`
* `$ rm spec/models/city_spec.rb`
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
  resources :cities, except: [:new, :edit]
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
    @foos = City.all
    # render json: @cities
  end

  def show
    # render json: @cities
  end

  def create
    @city = City.new(city_params)

    if @city.save
      #render json: @city, status: :created, location: @city
      render :show, status: :created, location: @city
    else
      render json: @city.errors, status: :unprocessable_entity
  end
```

* `$ rspec -e RDBMS -fd`

## 8. Implement an end-to-end thread from the API to the MongoDB database for a resource called States.

* The resource will have an id:BSON::ObjectId (default) and name:string property
* The resource name must be accessible via the /api/states URI
* The resource must be backed by MongoDB using Mongoid
* The resource will be deployed with a state with the name Maryland
* A client performing a GET of of the /api/states resource must at least get one state with name Maryland


* `$ rails g scaffold State name --orm mongoid --no-request-specs --no-routing-specs --no-controller-specs`
* `$ rm spec/models/state_spec.rb`
* edit models/state.rb to include `create_at` and `updated_at`, non include by default in MongoDB

```ruby
class State
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
end
```

* add default route in config/routes.rb with scope */api*:

```ruby
scope :api, defaults: {format: :json}  do
  resources :states, except: [:new, :edit]
end
```

* in the states_controller.rb delegate jbuilder for the view

```ruby
  def index
    @states = State.all
    #render json: @states
  end

  def show
    # render json: @state
  end

  def create
    @state = State.new(state_params)

    if @state.save
      #render json: @state, status: :created, location: @state
      render :show, status: :created, location: @state
    else
      render json: @state.errors, status: :unprocessable_entity
    end
  end
```

* to view mongoid id as string, change the app/views/states/_state.json.jbuilder :

```ruby
#json.extract! bar, :id, :name, :created_at, :updated_at
json.id bar.id.to_s
json.name bar.name
json.created_at bar.created_at
json.updated_at bar.updated_at
json.url bar_url(bar, format: :json)
```

* `$ rspec -e MongoDB -fd`


## 9. Configure your staging and production sites to require HTTPS for web communications

* config/production.rb: `config.force_ssl = true`
