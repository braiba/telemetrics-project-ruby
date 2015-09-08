require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get auth" do
    get :auth
    assert_response :success
  end

end
