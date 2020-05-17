require 'test_helper'

class PrivacypolicyControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get privacypolicy_index_url
    assert_response :success
  end

end
