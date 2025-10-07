require "test_helper"

class VersesControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get verses_search_url
    assert_response :success
  end
end
