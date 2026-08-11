require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
require "madmin"
require "madmin/static_models"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.action_controller.action_on_unpermitted_parameters = :raise
  end
end
