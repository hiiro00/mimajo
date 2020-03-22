require 'test_helper'

class RuleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rule_index_url
    assert_response :success
  end

end
