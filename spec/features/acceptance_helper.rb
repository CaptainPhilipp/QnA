# frozen_string_literal: true

require 'rails_helper'
require 'capybara/poltergeist'

require_relative '../support/feature_macros'

Capybara.javascript_driver = :poltergeist
Capybara.server = :puma

RSpec.configure do |config|
  config.include FeatureMacros, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with :truncation }
  config.before(:each)  { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each)  { DatabaseCleaner.start }
  config.after(:each)   { DatabaseCleaner.clean }

  # Ensure sphinx directories exist for the test environment
  # Configure and start Sphinx, and
  #   automatically stop Sphinx at the end of the test suite.
  config.before(:suite, type: :feature) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end
  # Index data when running an acceptance spec.
  config.before(:each, js: true) { index }
end
