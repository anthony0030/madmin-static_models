source "https://rubygems.org"

gemspec

# Until the extension load hooks PR is merged and released upstream
# (see https://github.com/excid3/madmin/pull/331 discussion):
gem "madmin", github: "anthony0030/madmin", branch: "extension-load-hooks"

group :development, :test do
  gem "rails"
  gem "propshaft"
  gem "sqlite3"
  gem "standard"
end
