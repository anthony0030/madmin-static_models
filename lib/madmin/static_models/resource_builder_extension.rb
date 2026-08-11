module Madmin
  module StaticModels
    # Prepended to Madmin::ResourceBuilder.
    module ResourceBuilderExtension
      def attributes
        adapter = StaticModels.adapter_for(model)
        adapter ? adapter.column_names(model) : super
      end
    end
  end
end
