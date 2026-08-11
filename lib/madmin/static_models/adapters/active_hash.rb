module Madmin
  module StaticModels
    module Adapters
      # Backend for active_hash models. Covers ActiveHash::Base and its
      # subclasses, which includes ActiveYaml::Base, ActiveJSON::Base and
      # ActiveFile::Base.
      class ActiveHash < Adapter
        # Abstract base classes shipped by the active_hash gem itself.
        BASE_CLASSES = %w[ActiveHash::Base ActiveFile::Base ActiveYaml::Base ActiveJson::Base ActiveJSON::Base]

        def self.handles?(model)
          model < ::ActiveHash::Base
        end

        def self.column_names(model)
          ([model.primary_key.to_s] + model.field_names.map(&:to_s)).uniq
        end

        def self.models
          ObjectSpace.each_object(::ActiveHash::Base.singleton_class).reject do |model|
            model.name.nil? || BASE_CLASSES.include?(model.name)
          end
        end
      end
    end
  end
end
