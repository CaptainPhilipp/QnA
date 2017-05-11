require 'rails_helper'

require_relative '../support/feature_macros'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit

  config.include FeatureMacros, type: :feature

  config.use_transactional_fixtures = false

  # перед запуском спеков, все таблицы дб обнуляются
  config.before(:suite) { DatabaseCleaner.clean_with :truncation }
  # для каждого теста, контролировать бд транзакционно
  config.before(:each)  { DatabaseCleaner.strategy = :transaction }
  # для каждого теста с js, контролировать бд обнулением
  config.before(:each, js: true)  { DatabaseCleaner.strategy = :truncation }
  # начать отслеживание по выбранной стратегии
  config.before(:each)  { DatabaseCleaner.start }
  # применить очищение по выбранной стратегии
  config.after(:each)   { DatabaseCleaner.clean }
end
