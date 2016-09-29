require 'test_helper'

class VisitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visit = visits(:one)
  end

  test "should get index" do
    get visits_url
    assert_response :success
  end

  test "should get new" do
    get new_visit_url
    assert_response :success
  end

  test "should create visit" do
    assert_difference('Visit.count') do
      post visits_url, params: { visit: { date_visit: @visit.date_visit, place_id: @visit.place_id } }
    end

    assert_redirected_to visit_url(Visit.last)
  end

  test "should show visit" do
    get visit_url(@visit)
    assert_response :success
  end

  test "should get edit" do
    get edit_visit_url(@visit)
    assert_response :success
  end

  test "should update visit" do
    patch visit_url(@visit), params: { visit: { date_visit: @visit.date_visit, place_id: @visit.place_id } }
    assert_redirected_to visit_url(@visit)
  end

  test "should destroy visit" do
    assert_difference('Visit.count', -1) do
      delete visit_url(@visit)
    end

    assert_redirected_to visits_url
  end
end
