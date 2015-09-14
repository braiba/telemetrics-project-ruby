require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should not login with invalid credentials' do
    post :auth, login: {
      username: 'DummyUsername1',
      password: 'incorrectPassword',
    }
    assert_redirected_to login_path
  end

  test 'should login with valid credentials' do
    post :auth, login: {
       username: 'DummyUsername1',
       password: 'password',
    }
    assert_redirected_to data_upload_path
  end

  test 'logout should clear session' do
    post :auth, login: {
        username: 'DummyUsername1',
        password: 'password',
    }
    assert_redirected_to data_upload_path

    assert session[:user_id]

    get :logout

    assert_nil session[:user_id]
  end

end
