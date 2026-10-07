require "test_helper"

class FiltersTest < ActionDispatch::IntegrationTest
  test "static resources offer no filters" do
    get madmin_countries_path
    assert_response :success
    assert_select "#filters", count: 0
  end

  test "ActiveRecord resources still offer filters" do
    get madmin_widgets_path
    assert_response :success
    assert_select "#filters"
  end

  test "filter params on a static resource are ignored" do
    # Sent as filters[][column]=name&filters[][operator]=eq&filters[][value]=Canada,
    # the format of Madmin's filters form
    get madmin_countries_path, params: {filters: [{column: "name", operator: "eq", value: "Canada"}]}
    assert_response :success
    assert_select "td", text: "Canada"
    assert_select "td", text: "Mexico"
  end
end
