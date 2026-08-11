require "rails/generators"
require "generators/madmin/install/install_generator"
require "generators/madmin/resource/resource_generator"

module Madmin
  module StaticModels
    module InstallGeneratorExtension
      def generate_resources
        generateable_models.each do |model|
          if StaticModels.static_model?(model) || model.table_exists?
            call_generator "madmin:resource", model.to_s
          else
            puts "Skipping #{model} because database table does not exist"
          end
        end
      end

      private

      def generateable_models
        static = StaticModels.adapters.flat_map(&:models).reject { |model| model.name.nil? }
        super.to_a + static
      end
    end

    module ResourceGeneratorExtension
      private

      def options_for_attribute(name)
        adapter = StaticModels.adapter_for(model)
        return super unless adapter

        if name == model.primary_key.to_s
          {form: false}
        elsif !adapter.column_names(model).include?(name)
          {index: false}
        end
      end
    end
  end
end

Madmin::Generators::InstallGenerator.prepend Madmin::StaticModels::InstallGeneratorExtension
Madmin::Generators::ResourceGenerator.prepend Madmin::StaticModels::ResourceGeneratorExtension
