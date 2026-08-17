source "https://rubygems.org"

gemspec

# Everything this gem needs is merged upstream (excid3/madmin#348, #350, #352)
# but not yet released; track upstream main until a release after 2.5.1:
gem "madmin", github: "excid3/madmin"

group :development, :test do
  gem "rails"
  gem "propshaft"
  gem "sqlite3"
  gem "standard"
end
