# grape_logging
ActiveSupport::Notifications.subscribe('grape_key') do |name, starts, ends, notification_id, payload|
  Rails.logger.info payload
end