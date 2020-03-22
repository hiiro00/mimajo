require 'test_helper'

class SelectroomControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get selectroom_index_url
    assert_response :success
  end

end
