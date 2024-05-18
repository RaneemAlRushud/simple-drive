require "test_helper"

class V1::BlobsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get v1_blobs_create_url
    assert_response :success
  end

  test "should get show" do
    get v1_blobs_show_url
    assert_response :success
  end
end
