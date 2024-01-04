# frozen_string_literal: true

module Service
  class Base
    def perform
      raise NotImplementedError
    end

    def name
      self.class.name.underscore
    end

    def tags
      name.split('/')
    end

    def call
      start_time = Time.now.to_f
      response = perform
      latency_duration = Time.now.to_f - start_time
      ms_duration = (latency_duration * 1000).round(5)

      log_entry = {
        service_name:   name,
        tags:           tags.push('service'),
        duration_in_ms: ms_duration
      }
      Rails.logger.info(log_entry)
      # Babypath::Metric.service_elapsed_time_seconds(name, 'success', latency_duration)

      response
    rescue => e
      latency_duration = Time.now.to_f - start_time
      ms_duration = (latency_duration * 1000).round(5)

      log_entry = {
        service_name:   name,
        tags:           tags.push('service'),
        duration_in_ms: ms_duration,
        message:        e.message,
        trace:          e.backtrace.slice(0, 10).join("\n")
      }

      Rails.logger.error(log_entry)
      # Babypath::Metric.service_elapsed_time_seconds(name, 'fail', latency_duration)

      raise e
    end
  end
end
