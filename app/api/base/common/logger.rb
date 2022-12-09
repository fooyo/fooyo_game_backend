require 'grape_logging'

module Base::Common::Logger
  extend ActiveSupport::Concern
  included do
    rescue_from Exception do |e|
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
    end
    rescue_from Grape::Exceptions::ValidationErrors do |e|
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
    end

    use GrapeLogging::Middleware::RequestLogger,
        instrumentation_key: 'grape_key',
        include: [
          # GrapeLogging::Loggers::Response.new,
          GrapeLogging::Loggers::FilterParameters.new
        ]
  end
end
