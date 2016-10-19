require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Faclabprojet0
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
<<<<<<< HEAD
    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = :fr
=======

config.i18n.enforce_available_locales = false    
config.i18n.locale = 'fr-fr'
config.i18n.available_locales = :fr
>>>>>>> 56a30dcda8d530a038276093c2ddc951c732c275
  end
end
