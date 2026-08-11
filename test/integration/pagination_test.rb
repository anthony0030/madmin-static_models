require "test_helper"

class PaginationTest < ActionDispatch::IntegrationTest
  test "index paginates a multi-page static collection" do
    get madmin_airports_path
    assert_response :success
    # Default sort is id desc, default limit 20: page 1 holds 25..6
    assert_match "Airport 25", response.body
    assert_no_match(/Airport 05/, response.body)
    # Nav helpers render (they need request context on the pagy object)
    assert_match(/page=2/, response.body)
  end

  test "second page renders the remaining records" do
    get madmin_airports_path(page: 2)
    assert_response :success
    assert_match "Airport 05", response.body
    assert_no_match(/Airport 25\b/, response.body)
  end
end
