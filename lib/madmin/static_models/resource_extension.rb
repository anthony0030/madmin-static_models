module Madmin
  module StaticModels
    # Prepended to Madmin::Resource's singleton class.
    module ResourceExtension
      def readonly?
        StaticModels.static_model?(model) || super
      end

      def model_column_names
        adapter = StaticModels.adapter_for(model)
        adapter ? adapter.column_names(model) : super
      end

      # Static records can't be passed to polymorphic_path (no #becomes,
      # not backed by ActiveModel routing), so build the paths by hand.
      def show_path(record)
        return super unless StaticModels.static_model?(model)

        "#{index_path}/#{record.id}"
      end

      def edit_path(record)
        return super unless StaticModels.static_model?(model)

        "#{index_path}/#{record.id}/edit"
      end

      def infer_type(name)
        return super unless StaticModels.static_model?(model)

        if model_column_names.include?(name.to_s)
          :string
        elsif model.respond_to?(:reflect_on_association) && (association = model.reflect_on_association(name))
          type_for_association(association)
        else
          :string
        end
      end
    end
  end
end
