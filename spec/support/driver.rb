# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :system) { driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] }
end
