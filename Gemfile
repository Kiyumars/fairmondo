source 'http://rubygems.org'

# Rails
gem 'rails', '~> 4.1.7'
gem 'rails-observers' # observers got extracted since rails 4
gem 'activerecord-session_store' # sessions in activerecord

# Plattforms Ruby
platforms :ruby do
  gem 'sqlite3', group: :test # sqlite3 for inmemory testing db
  gem 'therubyracer' # js runtime
  gem 'pg', group: [:production,:staging,:development] # postgres
end

# ----------  Model ----------

gem "paperclip", ">= 3.0" # image uploads
gem 'money-rails', '~> 0.12.0' # dealing with money in activerecord
gem 'monetize' # parsing money
gem 'enumerize', '>= 0.5.1' # enums as symbols in ar
gem 'state_machine' # State Machines in Rails
gem 'amoeba'
gem 'sanitize' # Parser based sanitization
gem 'awesome_nested_set' , ">= 3.0.0.rc.4"# tree structure for categories
gem "friendly_id", ">= 4.0.9" # Friendly_id for beautiful links

# pseudo models
gem 'active_data'

## Indexing /Searching
gem "chewy"

# ---------- View ----------
gem 'slim-rails'
gem 'jbuilder'

## CSS
gem 'susy' ,'~> 2.1.1' # Grid framework is susy
gem 'bourbon' # easy ccs3
gem "font-awesome-rails", '>= 4.2.0.0'
gem 'sprite-factory'
gem 'chunky_png' #needed for sprite-factory
gem 'sprockets', '2.11.0' #https://github.com/sstephenson/sprockets/issues/537

## JS
gem 'jquery-ui-rails'
gem 'qtip2-jquery-rails', '~> 2.1.107'
gem 'i18n-js'
gem 'coffee-rails'
gem 'therubyrhino'
gem 'selectivizr-rails'
gem 'uglifier'
gem 'modernizr-rails'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'jquery-rails'
gem 'rails-timeago'
gem 'wiselinks'
gem 'hogan_assets'

## Forms

gem 'formtastic', "~> 2.3.0.rc3"
gem "recaptcha", :require => "recaptcha/rails" #Captcha Gem



# ---------- Controller ----------

gem 'arcane' # Parameter management for strong_parameters
gem 'canonical-rails' # canonical view links
gem 'devise' # authentication
gem 'pundit' # authorization
gem 'kaminari' # pagination
gem 'responders'


# ---------- Mail ----------

gem 'premailer-rails' # creates emails with inline css from html files with external css-file

# ---------- Background Processing ----------

gem 'sidekiq', '>= 3.2.5'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'delayed_paperclip' # handle image processing with sidekiq
gem 'bluepill' #legacy, remove when eye stable
gem 'eye' # sidekiq process monitoring
gem 'sidetiq' # process scheduling

# ---------- Tools ----------

gem 'dalli' # Memcached Client
gem 'kontoapi-ruby' # KontoAPI checks bank data
gem 'ibanomat' # accound number to IBAN
gem 'memoist' # Support for memoization
gem 'rails_admin' # Administrative backend
gem 'rails_admin_statistics', github: 'KonstantinKo/rails_admin_statistics'
gem 'rack-rewrite' # Redirects
gem 'json'
gem 'nokogiri'
gem 'prawn_rails' # pdf generation

# ---------- Monitoring ----------
gem 'newrelic_rpm',  group: [:production,:staging]
gem 'rack-mini-profiler'
gem 'lograge'

# ---------- API ----------

# Gem for connecting to FastBill Automatic
gem 'fastbill-automatic', git: 'git://github.com/reputami/fastbill-automatic.git', tag: 'v0.0.3'

gem 'savon' # interacing with other SOAP apis:
gem 'rubyntlm' # https://github.com/savonrb/savon/issues/593

# Paypal integration
gem 'paypal_adaptive'

# ---------- Development ----------

group :development do
  gem 'spring' # faster rails start

  # Better error messages
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'letter_opener' # emails in browser

  # debugging in chrome with RailsPanel
  gem 'meta_request'

  # HAML Conversion tools
  #gem "erb2haml" see html2haml
  #gem "html2haml" need to wait for new release 2.0.0 is still in beta if you need it

  # Quiet Assets to disable asset pipeline in log
  gem 'quiet_assets'

  # er diagramm generation
  gem "rails-erd"
  gem 'thin' # Replace Webrick

end

group :test do
  gem 'memory_test_fix'  # Sqlite inmemory fix
  gem 'rake'
  gem 'database_cleaner'
  gem 'colorize'
  gem "fakeredis"
  gem "fakeweb", "~> 1.3"
end


group :development, :test do
  gem "parallel_tests"
  gem "pry-rescue"
  gem 'pry-rails' # pry is awsome
  gem 'hirb' # hirb makes pry output even more awesome
  gem 'pry-byebug' # kickass debugging
  gem 'pry-stack_explorer'

  # Capistrano
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv'

  gem 'minitest' # Testing using Minitest
  gem 'minitest-matchers'
  gem 'minitest-line'
  gem 'launchy' # save_and_open_page
  gem 'shoulda'
  gem 'minitest-rails-capybara'
  gem 'mocha'

  # Gem for testing emails
  gem "email_spec"

  # Code Coverage
  gem 'simplecov'
  gem 'simplecov-json', :require => false
  gem 'coveralls', require: false
  # Mutation Coverage
  # gem 'mutant-rails' ... check back to see if they got it working: https://github.com/mockdeep/mutant-rails

  # test suite additions
  gem "rails_best_practices"
  gem 'brakeman'  # security test: execute with 'brakeman'

  gem 'bullet' # Notify about n+1 queries
end



group :development,:test,:staging do
  gem 'factory_girl_rails'
  gem 'ffaker'
  # styleguides
  gem 'nkss-rails', github: 'nadarei/nkss-rails'

end
