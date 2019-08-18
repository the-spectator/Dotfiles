#
# Courtesy of https://gist.github.com/ivanoats/8480833
# Also refer https://github.com/excid3/jumpstart/blob/master/template.rb
#
require 'yaml'

def add_gems
  gem 'whenever', require: false
  gem 'sidekiq'
  gem 'fast_jsonapi'
  gem 'jwt'
  gem 'dotenv-rails'
  gem 'pghero'
  gem 'pg_query', '>= 0.9.0'

  serializer = ask 'Do you Want fast serialization? (y/n)'
  if ['yes', 'y'].include? serializer
    gem 'fast_jsonapi'
  else
    gem 'active_model_serializers', '~> 0.8.0'
  end

  gem_group :development do
    gem 'mina'
    gem 'bullet'
    gem 'rubocop', require: false
    gem 'rubocop-rails', require: false
    gem 'rubocop-rspec', require: false
    gem 'rubocop-performance', require: false
  end

  gem_group :test do
    gem 'simplecov', require: false
  end

  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'faker'
    gem 'factory_bot'
  end
end

def setup_sidekiq
  environment 'config.active_job.queue_adapter = :sidekiq'

  insert_into_file "config/routes.rb",
    "require 'sidekiq/web'\n\n",
    before: "Rails.application.routes.draw do"

  content = <<~RUBY
    # Sidekiq Basic Auth from routes on production environment
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['sidekiq_username'])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['sidekiq_password']))
    end

    mount Sidekiq::Web => '/sidekiq'
  RUBY
  insert_into_file 'config/routes.rb', "#{content}\n\n", after: "scope :monitoring do\n"
end

def add_monitoring_routes
  content = <<~RUBY
    scope :monitoring do
    end
  RUBY
end

def add_pg_dashboard
  route = <<~RUBY
    # PGHero Basic Auth from routes on production environment
    mount PgHero::Engine, at: 'pgdashboard'
  RUBY
  schedule = <<~SCHEDULE
    #Scheduled task for capturing PG query stats
    every 5.minutes do
      rake 'pghero:capture_query_stats'
    end
  SCHEDULE

  envs = <<~ENV
    #PGHERO CREDS
    PGHERO_USERNAME='username'
    PGHERO_PASSWORD='password'
  ENV

  insert_into_file 'config/routes.rb', "#{route}\n\n", after: "scope :monitoring do\n"
  append_to_file 'config/schedule.rb', "#{schedule}\n"
  append_to_file '.env', "#{envs}\n"

  instructions = <<~INST
    # ---- For ubuntu users ----
    cd /etc/postgresql/<version>/main
    vi postgresql.conf

    # Search for term 'shared_preload_libraries' & uncomment it
    /shared_preload_libraries
    # Set value of 'shared_preload_libraries' & add below mentioned code
    shared_preload_libraries = 'pg_stat_statements'         # (change requires restart)
    pg_stat_statements.track = all
    pg_stat_statements.max = 10000
    track_activity_query_size = 2048
    # Save changes

    #Restart the service
    sudo /etc/init.d/postgresql restart
  INST

  say instructions, :blue
end

def setup_whenever
  run 'wheneverize .'
end

def bundle_install
  run 'bundle install --path=vendor/bundle'
  # run 'bundle install'
end

def setup_dotenv
  run 'touch .env'
end

def setup_database_yml
  config_hash = {'development' => 'dev', 'test' => 'test', 'production' => 'prod'}
  envs = ''
  # database_config_path = 'database.yml'
  # database_config = nil

  run 'cp config/database.yml config/database.yml.sample'

  # inside 'config' do
  #   database_config = database_config_path.yield_self do |file_name|
  #     File.open(file_name).yield_self do |config|
  #       YAML.load(config)
  #     end
  #   end
  # end

  config_hash.each do |key, value|
    envs += <<~ENV
      # #{key} DB CREDS
      #{value.upcase}_DB="#{@app_name}_#{key}"
      #{value.upcase}_USER='postgres'
      #{value.upcase}_PASSWORD='postgres'
      #{value.upcase}_HOST='localhost'
      #{value.upcase}_PORT=5432
      #{value.upcase}_POOL=10

    ENV

    # database_config[key]['database'] = "<%= ENV['#{value.upcase}_DB'] %>"
    # database_config[key]['username'] = "<%= ENV['#{value.upcase}_USER'] %>"
    # database_config[key]['password'] = "<%= ENV['#{value.upcase}_PASSWORD'] %>"
    # database_config[key]['host'] = "<%= ENV['#{value.upcase}_HOST'] %>"
    # database_config[key]['port'] = "<%= ENV['#{value.upcase}_PORT'] %>"
    # database_config[key]['pool'] = "<%= ENV['#{value.upcase}_POOL'] %>"
  end

  append_to_file '.env', "#{envs}\n"
  # inside('config') do
  #   File.open(database_config_path, 'w') {|f| f.write(database_config.to_yaml) }
  # end
end

add_gems
bundle_install

after_bundle do
  setup_dotenv
  setup_sidekiq
  setup_whenever
  setup_database_yml
  add_monitoring_routes
  add_pg_dashboard

  # Migrate
  rails_command 'db:create'
  generate('pghero:query_stats')
  rails_command 'db:migrate'
  copy '.rubocop.yml'

  # Commit everything to git
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }

  say
  say "API template Completed", :blue
  say
  say "To get started with your new app:", :green
  say "Please Switch to your new app's directory."
end
