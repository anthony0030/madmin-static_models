# Madmin Static Models

Browse read-only, in-memory models in your [Madmin](https://github.com/excid3/madmin) admin.

Supports [active_hash](https://github.com/active-hash/active_hash) models out of the box — `ActiveHash::Base`, `ActiveYaml::Base`, `ActiveJson::Base` and `ActiveFile::Base` — with an adapter layer for adding other static backends (e.g. frozen_record) later.

Static resources get:

- Index, show, search, sorting and pagination — all done in memory, no SQL
- Automatic read-only behavior: no new/edit/delete links, write actions redirect away
- Generator support: `rails g madmin:install` and `rails g madmin:resource` pick up static models

## Installation

Add to your Gemfile:

```ruby
gem "madmin-static_models"

# Everything this gem needs is merged in madmin's main branch, but until a
# release after 2.5.1 ships, point madmin at upstream main:
gem "madmin", github: "excid3/madmin"
```

## Usage

Define a static model:

```ruby
class Country < ActiveHash::Base
  fields :name, :code

  self.data = [
    {id: 1, name: "United States", code: "US"},
    {id: 2, name: "Canada", code: "CA"}
  ]
end
```

Generate its admin resource (or write it by hand):

```bash
rails g madmin:resource Country
```

```ruby
class CountryResource < Madmin::Resource
  attribute :id, form: false
  attribute :name
  attribute :code
end
```

That's it — the resource shows up in Madmin like any other, minus the write actions.

## How it works

The gem attaches to Madmin through its `ActiveSupport` load hooks (`:madmin_resource`, `:madmin_resource_controller`) and prepends small modules that answer differently for static models and call `super` for everything else:

- `Resource.readonly?` returns true, which makes Madmin hide write links and block write actions
- `Resource.model_column_names` comes from the adapter instead of the database
- Pagination, sorting and search run over plain arrays in memory
- `show_path`/`edit_path` are built manually since static records don't support polymorphic routing

## Adding a backend

An adapter is a class with three methods. Register it and matching models are treated as static:

```ruby
class FrozenRecordAdapter < Madmin::StaticModels::Adapter
  def self.handles?(model)
    model < ::FrozenRecord::Base
  end

  def self.column_names(model)
    [model.primary_key.to_s, *model.attributes].uniq
  end

  def self.models
    ::FrozenRecord::Base.descendants
  end
end

Madmin::StaticModels.register(FrozenRecordAdapter)
```

## Development

```bash
bundle install
bundle exec rake test
```

## License

MIT
