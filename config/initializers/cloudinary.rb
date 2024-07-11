# frozen_string_literal: true

# Configuration values for your account are available
# in Cloudinary's Management Console (https://cloudinary.com/console)

Cloudinary.config do |config|
  config.cloud_name = ENV.fetch("CLOUDINARY_CLOUD_NAME", nil)
  config.api_key = ENV.fetch("CLOUDINARY_API_KEY", nil)
  config.api_secret = ENV.fetch("CLOUDINARY_API_SECRET", nil)
end
