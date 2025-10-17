Pay.setup do |config|
  config.automount_routes = false # We'll define our own webhook routes
  config.apple_iap_enabled = true
  config.google_billing_enabled = true
  config.stripe_enabled = true
end