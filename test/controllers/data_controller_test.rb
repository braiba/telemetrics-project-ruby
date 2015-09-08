require 'test_helper'

class DataControllerTest < ActionController::TestCase
  test "should get upload" do
    get :upload
    assert_response :success
  end

  test "should get map" do
    get :map
    assert_response :success
  end

  test "should get stats" do
    get :stats
    assert_response :success
  end

  test "should get chart" do
    get :chart
    assert_response :success
  end

  test "should get select" do
    get :select
    assert_response :success
  end

end
