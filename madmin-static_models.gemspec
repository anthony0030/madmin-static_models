$:.push File.expand_path("lib", __dir__)

require "madmin/static_models/version"

Gem::Specification.new do |spec|
  spec.name = "madmin-static_models"
  spec.version = Madmin::StaticModels::VERSION
  spec.authors = ["Anthony Veaudry"]
  spec.email = ["anthony@veaudry.pro"]
  spec.homepage = "https://github.com/anthony0030/madmin-static_models"
  spec.summary = "Static model support (ActiveHash, ActiveYaml, ...) for Madmin"
  spec.description = "Browse read-only, in-memory models like ActiveHash and ActiveYaml in your Madmin admin, with an adapter layer for adding other static backends."
  spec.license = "MIT"

  spec.files = Dir["lib/**/*", "MIT-LICENSE", "README.md", "CHANGELOG.md"]

  spec.required_ruby_version = ">= 3.2.0"

  spec.add_dependency "madmin", ">= 2.4"
  spec.add_dependency "active_hash", ">= 3.0"
end
