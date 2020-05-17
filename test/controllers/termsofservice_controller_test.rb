require 'test_helper'

class TermsofserviceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get termsofservice_index_url
    assert_response :success
  end

end
