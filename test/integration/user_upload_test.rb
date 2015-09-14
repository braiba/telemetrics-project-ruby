require 'test_helper'

class UserUploadTest < ActionDispatch::IntegrationTest

  test 'upload test csv' do
    # must be logged in to upload
    post login_auth_path, login: {username: 'DummyUsername1', password: 'password'}

    # upload the file
    file_upload = fixture_file_upload(Rails.root.to_s + '/test/fixtures/dummy_telemetrics.csv', 'text/csv')
    post data_handle_upload_path, {journey_csv: file_upload}

    assert_not_nil session[:journey_id]
    assert_same 6014, Journey.find(session[:journey_id]).journey_datums.length
  end
end
