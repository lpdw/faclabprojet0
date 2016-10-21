require_relative 'boot'

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Faclabprojet0
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.i18n.enforce_available_locales = false
    config.i18n.locale = 'fr-fr'
    config.i18n.available_locales = :fr
  end
end
def current_class?(test_path)
  return 'active' if request.path == test_path
  ''
end
