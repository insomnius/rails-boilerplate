# frozen_string_literal: true

return if ENV['DOCKER_BUILD'] == '1' # if docker build then skip
return unless ENV['OPENAI_ACCESS_TOKEN']

OpenAI.configure do |config|
  config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
end
