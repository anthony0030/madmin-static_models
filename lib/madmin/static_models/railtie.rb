module Madmin
  module StaticModels
    class Railtie < ::Rails::Railtie
      initializer "madmin.static_models" do |app|
        # Madmin::ResourceController is reloadable, so patch it lazily via
        # madmin's load hook whenever it (re)loads.
        ActiveSupport.on_load(:madmin_resource_controller) do
          prepend Madmin::StaticModels::ControllerExtension
        end

        ActiveSupport.on_load(:madmin_resource) do
          singleton_class.prepend Madmin::StaticModels::ResourceExtension
        end

        # Plain lib classes; referencing them triggers madmin's autoload.
        Madmin::Search.prepend Madmin::StaticModels::SearchExtension
        Madmin::ResourceBuilder.prepend Madmin::StaticModels::ResourceBuilderExtension

        app.config.after_initialize do
          unless Madmin::Resource.singleton_class.include?(Madmin::StaticModels::ResourceExtension)
            # The :madmin_resource load hook never fired, so this madmin
            # predates the extension seams (readonly?, model_column_names,
            # paginate_collection) that this gem builds on.
            warn "madmin-static_models requires a madmin version with extension load hooks and seams " \
              "(excid3/madmin#348, #352). Until they are released, use: gem \"madmin\", github: \"anthony0030/madmin\""
          end
        end
      end

      generators do
        require "madmin/static_models/generator_extensions"
      end
    end
  end
end
