require "rails_helper"
require 'securerandom' 

RSpec.describe "Blob API request", type: :request do
  describe "POST/Get /v1/blobs/" do
    
    it "returns http 201 if blob posted successfully" do
      user = create(:user)

      headers = {}
      headers["Authorization"] = "Bearer #{user.api_token}"

      post "/v1/blobs/", params: {
          id: "SecureRandom.uuid",
          data: Base64.encode64("some-random-data"),
      }, headers: headers, as: :json

      expect(response).to have_http_status(201)
    end

    it "returns http 200 if blob exists" do
      user = create(:user)
      blob_id = SecureRandom.uuid
      blob_data = Base64.encode64("some-random-data")

      headers = {}
      headers["Authorization"] = "Bearer #{user.api_token}"

      post "/v1/blobs/", params: {
        id: blob_id,
        data: blob_data,
    }, headers: headers, as: :json
    
      get "/v1/blobs/#{blob_id}", headers: headers, as: :json
    
      expect(response).to have_http_status(200)
    end


    it "returns http 401 if unauthenticated" do
      user = create(:user)

      post "/v1/blobs/", params: {
          id: "unique-id",
          data: "some-random-data",
        }

      expect(response).to have_http_status(401)
    end

    it "returns http 400 if invalid base64" do
      user = create(:user)

      headers = {}
      headers["Authorization"] = "Bearer #{user.api_token}"

      post "/v1/blobs/", params: {
          id: "unique-id-2",
          data: "some-random-data",
      }, headers: headers, as: :json

      expect(response).to have_http_status(400)
    end

    it "returns http 400 if duplicate id" do
      user = create(:user)
      blob = create(:blob)

      headers = {}
      headers["Authorization"] = "Bearer #{user.api_token}"

      post "/v1/blobs/", params: {
          id: blob.id,
          data: Base64.encode64("some data"),
      }, headers: headers, as: :json

      expect(response).to have_http_status(400)
    end
  end
end
