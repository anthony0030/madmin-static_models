module Madmin
  module StaticModels
    # Base class for static model backends. An adapter declares which model
    # classes it manages and how to introspect them. Register one with:
    #
    #   Madmin::StaticModels.register(MyAdapter)
    class Adapter
      # True if this adapter manages the given model class.
      def self.handles?(model)
        false
      end

      # Ordered attribute names (strings) for the model, primary key first.
      def self.column_names(model)
        []
      end

      # All model classes managed by this adapter that are currently loaded.
      # Used by the install generator to create resources.
      def self.models
        []
      end
    end
  end
end
