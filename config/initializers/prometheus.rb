# frozen_string_literal: true

return unless Rails.env.production?
return if ENV['DOCKER_BUILD'] == '1' # if docker build then skip

require 'prometheus_exporter/middleware'
require 'prometheus_exporter/instrumentation'

Rails.application.middleware.unshift PrometheusExporter::Middleware
PrometheusExporter::Instrumentation::Process.start(type: 'master')
