# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'rspec/autorun'
require 'spec_helper'
require 'spork'
require 'database_cleaner'
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  RSpec.configure do |config|
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    # Include Factory Girl syntax to simplify calls to factories
    config.include FactoryGirl::Syntax::Methods

    config.before :each do
      if Capybara.current_driver == :selenium
        DatabaseCleaner.strategy = :truncation
      else
        DatabaseCleaner.strategy = :transaction
      end
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)

    #config.filter_run focus: true
    #config.raise_errors_for_deprecations!
  end
end

Spork.each_run do
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  FactoryGirl.reload
  include LoginMacros
end
