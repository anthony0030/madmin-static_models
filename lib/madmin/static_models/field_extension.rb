module Madmin
  module StaticModels
    # Prepended to Madmin::Field. Madmin's index filters build SQL, which
    # static models can't run, so their fields offer no filters.
    module FieldExtension
      def filter_type
        return nil if StaticModels.static_model?(model)

        super
      end
    end
  end
end
