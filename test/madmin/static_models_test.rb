require "test_helper"

class StaticModelsTest < ActiveSupport::TestCase
  test "detects static models" do
    assert Madmin::StaticModels.static_model?(Country)
    assert_not Madmin::StaticModels.static_model?(Widget)
    assert_not Madmin::StaticModels.static_model?("not a class")
  end

  test "uses the ActiveHash adapter for active_hash models" do
    assert_equal Madmin::StaticModels::Adapters::ActiveHash, Madmin::StaticModels.adapter_for(Country)
    assert_nil Madmin::StaticModels.adapter_for(Widget)
  end

  test "static resources are readonly" do
    assert CountryResource.readonly?
    assert_not WidgetResource.readonly?
  end

  test "model_column_names uses adapter columns" do
    assert_equal %w[id name code], CountryResource.model_column_names
  end

  test "sortable_columns uses adapter columns" do
    assert_equal %w[id name code], CountryResource.sortable_columns
  end

  test "infers string type for active_hash fields" do
    assert_equal :string, CountryResource.attributes[:name].type
    assert_equal :string, CountryResource.attributes[:code].type
  end

  test "searchable_attributes includes active_hash string fields" do
    names = CountryResource.searchable_attributes.map(&:name)
    assert_includes names, :name
    assert_includes names, :code
  end

  test "search filters records in memory" do
    relation = Madmin::Search.new(Country, CountryResource, "canada").run
    assert_equal ["Canada"], relation.map(&:name)
  end

  test "search returns all records when query is blank" do
    assert_equal 3, Madmin::Search.new(Country, CountryResource, "").run.count
  end

  test "model_find finds records" do
    assert_equal "Canada", CountryResource.model_find(2).name
  end

  test "show and edit paths are built without polymorphic routing" do
    country = Country.find(2)
    assert_equal "/madmin/countries/2", CountryResource.show_path(country)
    assert_equal "/madmin/countries/2/edit", CountryResource.edit_path(country)
  end

  test "resource builder lists adapter columns" do
    assert_equal %w[id name code], Madmin::ResourceBuilder.new(Country).attributes
  end
end
