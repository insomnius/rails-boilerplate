# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Dotenv.load! unless Rails.env.production? && if ENV['DOCKER_BUILD'] == '1' # if docker build then skipDotenv.load!
Rails.application.load_tasks
