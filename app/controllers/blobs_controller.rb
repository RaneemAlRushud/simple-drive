require 'base64'
class BlobsController < ApplicationController
  before_action :authenticate

  def create
    id = params[:id]
    data = params[:data]

    if Blob.exists?(id: params[:id])
      render json: {
        error: 'Blob already exists'
      }, status: :bad_request
    elsif !is_valid_base64?(data)
      render json: {
        error: 'Not valid base64'
      }, status: :bad_request
    else
      storage = Storage.new
      metadata = storage.store(id, data)
      @blob = Blob.create(user: @current_user, id: params[:id], storage_metadata: metadata)

      render json: {
        "id": @blob.id,
        "success": true,
      }, status: :created
    end
  end

  def show
    storage = Storage.new
    @blob = Blob.find_by(id: params[:id], user: @current_user)
    if @blob.nil?
      render json: {
        "error": 'Not found'
      }, status: :not_found
    else
      blob_data = storage.retrieve(@blob.storage_metadata)
      render json: {
        "id": @blob.id,
        "data": blob_data,
        "size": blob_data.bytesize,
        "created_at": @blob.created_at
      }, status: :ok
    end
  end

  private
  def is_valid_base64?(value)
    return false if !value.is_a?(String)
    encoded_value = Base64.strict_encode64(Base64.decode64(value))
    # No need to compare == padding
    encoded_value.gsub("=", "") == value.chomp.gsub("=", "")
  end
end
