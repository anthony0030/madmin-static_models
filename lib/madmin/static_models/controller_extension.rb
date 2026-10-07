module Madmin
  module StaticModels
    # Prepended to Madmin::ResourceController.
    module ControllerExtension
      private

      def scoped_resources
        return super unless StaticModels.static_model?(resource.model)

        resources = resource.model.send(valid_scope)
        resources = Madmin::Search.new(resources, resource, search_term).run

        return resources if sort_column.blank?

        sort_static(resources, sort_column, sort_direction)
      end

      def paginate_collection(collection)
        return super unless StaticModels.static_model?(resource.model)

        paginate_static(collection)
      end

      def paginate_static(collection)
        records = collection.to_a
        page = Madmin::Page.new(count: records.size, page: params[:page], per_page: Madmin::Page.per_page_for(params[:per_page]))
        [page, records.slice(page.offset, page.per_page) || []]
      end

      def sort_static(collection, column, direction)
        records = collection.to_a.sort do |a, b|
          a_value = a.public_send(column) if a.respond_to?(column)
          b_value = b.public_send(column) if b.respond_to?(column)
          if a_value.nil? || b_value.nil?
            # Sort records without a value last
            (a_value.nil? ? 1 : 0) <=> (b_value.nil? ? 1 : 0)
          else
            (a_value <=> b_value) || (a_value.to_s <=> b_value.to_s)
          end
        end
        (direction.to_s == "desc") ? records.reverse : records
      end
    end
  end
end
