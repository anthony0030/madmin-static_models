class CountryResource < Madmin::Resource
  attribute :id, form: false
  attribute :name
  attribute :code
end
