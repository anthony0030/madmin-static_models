require "test_helper"

class CountriesTest < ActionDispatch::IntegrationTest
  test "index lists records without new or edit links" do
    get madmin_countries_path
    assert_response :success
    assert_select "td", text: "Canada"
    assert_select "a[href=?]", "/madmin/countries/new", count: 0
    assert_select "a[href=?]", "/madmin/countries/2/edit", count: 0
  end

  test "index searches in memory" do
    get madmin_countries_path(q: "canada")
    assert_response :success
    assert_select "td", text: "Canada"
    assert_select "td", text: "Mexico", count: 0
  end

  test "index sorts in memory" do
    get madmin_countries_path(sort: "name", direction: "asc")
    assert_response :success
    assert_match(/Canada.*Mexico.*United States/m, response.body)

    get madmin_countries_path(sort: "name", direction: "desc")
    assert_response :success
    assert_match(/United States.*Mexico.*Canada/m, response.body)
  end

  test "show renders a record" do
    get "/madmin/countries/2"
    assert_response :success
    assert_match "Canada", response.body
  end

  test "write actions redirect to the index" do
    get "/madmin/countries/new"
    assert_redirected_to madmin_countries_path

    post madmin_countries_path, params: {country: {name: "Nope"}}
    assert_redirected_to madmin_countries_path

    get "/madmin/countries/2/edit"
    assert_redirected_to madmin_countries_path

    delete "/madmin/countries/2"
    assert_redirected_to madmin_countries_path
    assert_equal 3, Country.count
  end

  test "regular active record resources still work" do
    Widget.create!(name: "Sprocket")
    get madmin_widgets_path
    assert_response :success
    assert_match "Sprocket", response.body
  end
end
