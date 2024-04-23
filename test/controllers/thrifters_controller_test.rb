require "test_helper"

class ThriftersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @thrifter = thrifters(:one)
  end

  test "should get index" do
    get thrifters_url, as: :json
    assert_response :success
  end

  test "should create thrifter" do
    assert_difference("Thrifter.count") do
      post thrifters_url, params: { thrifter: { address: @thrifter.address, experience_level: @thrifter.experience_level, preferences: @thrifter.preferences, user_id: @thrifter.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show thrifter" do
    get thrifter_url(@thrifter), as: :json
    assert_response :success
  end

  test "should update thrifter" do
    patch thrifter_url(@thrifter), params: { thrifter: { address: @thrifter.address, experience_level: @thrifter.experience_level, preferences: @thrifter.preferences, user_id: @thrifter.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy thrifter" do
    assert_difference("Thrifter.count", -1) do
      delete thrifter_url(@thrifter), as: :json
    end

    assert_response :no_content
  end
end
