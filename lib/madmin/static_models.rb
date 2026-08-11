require "madmin"
require "active_hash"

require "madmin/static_models/version"
require "madmin/static_models/adapter"
require "madmin/static_models/adapters/active_hash"
require "madmin/static_models/resource_extension"
require "madmin/static_models/resource_builder_extension"
require "madmin/static_models/controller_extension"
require "madmin/static_models/search_extension"
require "madmin/static_models/railtie"

module Madmin
  module StaticModels
    class << self
      def adapters
        @adapters ||= []
      end

      def register(adapter)
        adapters << adapter unless adapters.include?(adapter)
      end

      # Returns the adapter that manages this model class, or nil for
      # regular (ActiveRecord) models.
      def adapter_for(model)
        return nil unless model.is_a?(Class)

        adapters.find { |adapter| adapter.handles?(model) }
      end

      def static_model?(model)
        !adapter_for(model).nil?
      end
    end
  end
end

Madmin::StaticModels.register(Madmin::StaticModels::Adapters::ActiveHash)
