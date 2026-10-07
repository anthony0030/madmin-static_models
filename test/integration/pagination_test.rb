require "test_helper"

class PaginationTest < ActionDispatch::IntegrationTest
  test "index paginates a multi-page static collection" do
    get madmin_airports_path
    assert_response :success
    # Default sort is id desc, default limit 20: page 1 holds 25..6
    assert_match "Airport 25", response.body
    assert_no_match(/Airport 05/, response.body)
    # The nav renders links from the Madmin::Page
    assert_match(/page=2/, response.body)
  end

  test "second page renders the remaining records" do
    get madmin_airports_path(page: 2)
    assert_response :success
    assert_match "Airport 05", response.body
    assert_no_match(/Airport 25\b/, response.body)
  end

  test "per_page sets the page size" do
    get madmin_airports_path(per_page: 10)
    assert_response :success
    assert_select "tbody tr", count: 10
    assert_match "Airport 16", response.body
    assert_no_match(/Airport 15/, response.body)
    # 25 records at 10 per page make 3 pages
    assert_match(/page=3/, response.body)
  end

  test "a page past the end renders empty" do
    get madmin_airports_path(page: 99)
    assert_response :success
    assert_no_match(/Airport \d\d/, response.body)
  end
end
