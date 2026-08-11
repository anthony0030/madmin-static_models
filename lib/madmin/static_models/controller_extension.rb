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
        page = [params[:page].to_i, 1].max
        defaults = Pagy::DEFAULT || {}
        limit = (params[:limit] || defaults[:limit] || defaults[:items] || 20).to_i
        pagy_class = defined?(Pagy::Offset) ? Pagy::Offset : Pagy
        pager = begin
          pagy_class.new(count: records.size, page: page, limit: limit)
        rescue ArgumentError
          pagy_class.new(count: records.size, page: page, items: limit)
        end
        per_page = pager.respond_to?(:limit) ? pager.limit : pager.items
        [pager, records.slice(pager.offset, per_page) || []]
      end

      def sort_static(collection, column, direction)
        records = collection.to_a.sort_by do |record|
          value = record.public_send(column) if record.respond_to?(column)
          [value.nil? ? 1 : 0, value.to_s]
        end
        (direction.to_s == "desc") ? records.reverse : records
      end
    end
  end
end
