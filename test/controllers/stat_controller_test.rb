require 'test_helper'

class StatControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get stat_home_url
    assert_response :success
  end

end
