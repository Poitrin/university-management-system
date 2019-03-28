require_relative 'boot'

require 'rails/all'

# require 'carrierwave'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UniversityManagementSystem
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # config.assets.paths << "vendor/assets/uikit/dist"

    # The default locale loading mechanism in Rails does not load locale files in nested dictionaries, like we have here.
    # So, for this to work, we must explicitly tell Rails to look further:
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
