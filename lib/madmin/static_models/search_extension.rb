module Madmin
  module StaticModels
    # Prepended to Madmin::Search. Static models have no SQL backend, so
    # search filters records in memory instead.
    module SearchExtension
      def run
        return super unless StaticModels.static_model?(@resource.model)
        return @scoped_resource.all if query.blank?

        static_search(@scoped_resource)
      end

      private

      def static_search(resources)
        pattern = Regexp.new(Regexp.escape(query), Regexp::IGNORECASE)
        fields = search_attributes.flat_map { |attribute| searchable_fields(attribute) }
        matched = resources.all.select do |record|
          fields.any? { |field| record.respond_to?(field) && record.public_send(field).to_s.match?(pattern) }
        end
        resources.respond_to?(:where) ? resources.where(id: matched.map(&:id)) : matched
      end
    end
  end
end
