# frozen_string_literal: true

# For more options, see https://docs.honeybadger.io/lib/ruby/gem-reference/configuration
Honeybadger.configure do |config|
  config.api_key = ENV.fetch("HONEYBADGER_API_KEY", nil)

  # The environment the app is running in.
  config.env = Rails.env

  # The absolute path to the project folder.
  config.root = Rails.root.to_s

  # Honeybadger won't report errors in these environments.
  config.development_environments = %w[development test]

  # By default, Honeybadger won't report errors in the development_environments.
  # You can override this by explicitly setting report_data to true or false.
  # config.report_data = true

  # The current Git revision of the project. Defaults to the last commit hash.
  # config.revision = nil

  # Enable verbose debug logging (useful for troubleshooting).
  config.debug = false

  # Enable Honeybadger Insights.
  config.insights.enabled = true

  # We can also use the `before_event` callback to inspect or modify event data,
  # as well as calling `halt!` to prevent the event from being sent to Honeybadger.
  config.before_event do |event|
    # Ignore health check requests
    if event.event_type == "process_action.action_controller" && event[:controller] == "Rails::HealthController"
      event.halt!
    end

    # DB-backed job backends can generate a lot of noisy queries
    # event.halt! if event.event_type == "sql.active_record" && event[:query]&.match?(/good_job|solid_queue/)
  end
end
