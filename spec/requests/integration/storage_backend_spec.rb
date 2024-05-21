require "rails_helper"
require 'securerandom' 

RSpec.describe "Storage backend integration tests", type: :request do
  describe "stores and retrieve" do

    it "returns store and retrieve from FTP" do
      ENV['DEFAULT_STORAGE_BACKEND']="ftp"
      user = create(:user)
      headers = {}
      headers["Authorization"] = "Bearer #{user.api_token}"

      id = SecureRandom.uuid
      data = Base64.encode64("some data")

      post "/v1/blobs/", params: {
          id: id,
          data: data,
      }, headers: headers, as: :json

      expect(response).to have_http_status(201)

      get "/v1/blobs/#{id}", headers: headers, as: :json
      expect(response).to have_http_status(200)

      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(id)
      expect(json_response["data"]).to eq(data)
    end

    it "returns stores and retrieve from DB" do
      ENV['DEFAULT_STORAGE_BACKEND']="db"
      user = create(:user)
      headers = {}
      headers["Authorization"] = "Bearer #{user.api_token}"

      id = SecureRandom.uuid
      data = Base64.encode64("some data")

      post "/v1/blobs/", params: {
          id: id,
          data: data,
      }, headers: headers, as: :json

      expect(response).to have_http_status(201)

      get "/v1/blobs/#{id}", headers: headers, as: :json
      expect(response).to have_http_status(200)

      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(id)
      expect(json_response["data"]).to eq(data)
    end

    it "returns stores and retrieve from S3" do
      ENV['DEFAULT_STORAGE_BACKEND']="s3_compatible"
      user = create(:user)
      headers = {}
      headers["Authorization"] = "Bearer #{user.api_token}"

      id = SecureRandom.uuid
      data = Base64.encode64("some data")

      post "/v1/blobs/", params: {
          id: id,
          data: data,
      }, headers: headers, as: :json

      expect(response).to have_http_status(201)

      get "/v1/blobs/#{id}", headers: headers, as: :json
      expect(response).to have_http_status(200)

      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(id)
      expect(json_response["data"]).to eq(data)
    end

    it "returns stores and retrieve from local" do
      ENV['DEFAULT_STORAGE_BACKEND']="local"
      user = create(:user)
      headers = {}
      headers["Authorization"] = "Bearer #{user.api_token}"

      id = SecureRandom.uuid
      data = Base64.encode64("some data")

      post "/v1/blobs/", params: {
          id: id,
          data: data,
      }, headers: headers, as: :json

      expect(response).to have_http_status(201)

      get "/v1/blobs/#{id}", headers: headers, as: :json
      expect(response).to have_http_status(200)

      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(id)
      expect(json_response["data"]).to eq(data)
    end

  end
end
