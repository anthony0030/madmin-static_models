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

        # Pagy >= 43 paginates plain arrays natively, with the request context
        # that its nav helpers need.
        return pagy(records) if defined?(Pagy::Method) && is_a?(Pagy::Method)

        # Older pagy: build the pager by hand.
        page = [params[:page].to_i, 1].max
        defaults = Pagy::DEFAULT || {}
        limit = (params[:limit] || defaults[:limit] || defaults[:items] || 20).to_i
        pager = begin
          Pagy.new(count: records.size, page: page, limit: limit)
        rescue ArgumentError
          Pagy.new(count: records.size, page: page, items: limit)
        end
        per_page = pager.respond_to?(:limit) ? pager.limit : pager.items
        [pager, records.slice(pager.offset, per_page) || []]
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
