# frozen_string_literal: true

# You can store secrets in Rails credentials
#
# `EDITOR="code --wait" rails credentials:edit`
#
# Use:
#
# `Rails.application.credentials.dig(:stripe, :secret_key)`
#
# `Rails.application.credentials.dig(:stripe, :webhook_secret)`
STRIPE_SECRET_KEY = ENV.fetch("STRIPE_SECRET_KEY", nil)
STRIPE_WEBHOOK_SECRET = ENV.fetch("STRIPE_WEBHOOK_SECRET", nil)

Stripe.api_key = STRIPE_SECRET_KEY
