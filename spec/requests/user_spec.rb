require "rails_helper"

RSpec.describe "User API request", type: :request do
  describe "POST /v1/token" do

    it "returns http 200 with token" do
      post "/v1/token", params: {
          email: "test@example.com",
        }

      expect(response).to have_http_status(200)

      latest_user = User.last

      expect(latest_user.email).to eq("test@example.com")

      json_response = JSON.parse(response.body)
      expect(json_response["token"]).to eq(latest_user.api_token)
    end

    it "returns http 200 if existing email passed" do
      user = create(:user)
      user_count = User.count

      post "/v1/token", params: {
          email: user.email,
        }

      expect(response).to have_http_status(200)

      latest_user_count = User.count

      expect(user_count).to eq(latest_user_count)

      json_response = JSON.parse(response.body)
      expect(json_response["token"]).to eq(user.api_token)
    end
  end
end
