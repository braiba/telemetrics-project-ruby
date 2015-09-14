require 'test_helper'

class DataControllerTest < ActionController::TestCase

  test 'should get upload if logged in' do
    session[:user_id] = 1
    get :upload
    assert_response :success
  end

  test 'should fail, because no file was uploaded' do
    session[:user_id] = 1
    post :handle_upload
    assert_equal 'Upload failed', flash[:danger]
    assert_redirected_to data_upload_path
  end

  test 'should redirect if not logged in' do
    get :upload
    assert_redirected_to login_path
  end

  test 'should get map if logged in with journey' do
    session[:user_id]    = 1
    session[:journey_id] = 1
    get :map
    assert_response :success
  end

  test 'should redirect if no journey selected' do
    session[:user_id] = 1
    get :map
    assert_redirected_to data_upload_path
  end

  test 'should get stats if logged in with journey' do
    session[:user_id]    = 1
    session[:journey_id] = 1
    get :stats
    assert_response :success
  end

  test 'should get chart if logged in with journey' do
    session[:user_id]    = 1
    session[:journey_id] = 1
    get :chart
    assert_response :success
  end

  test 'should view the chart page by selecting a journey with the action' do
    session[:user_id] = 1
    post :select_journey, {id: 1}
    get :chart
    assert_response :success
  end

  test 'should get select if logged in' do
    session[:user_id] = 1
    get :select
    assert_response :success
  end

end
