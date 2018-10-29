require 'drb/drb'

SERVER_URI = "druby://localhost:8787"

DRb.start_service

log_service = DRbObject.new_with_uri(SERVER_URI)

["loga", "logb", "logc"].each do |logname|

  logger = log_service.get_logger(logname)

  1000.times do
    logger.log("Hello, DRb~")
    logger.log("Goodbye, DRb!")
    logger.log("=== EOT ===")
  end
end