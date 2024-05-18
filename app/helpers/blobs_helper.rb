require 'base64'

module BlobsHelper
  def is_valid_base64?(value)
    return false if !value.is_a?(String)
    encoded_value = Base64.strict_encode64(Base64.decode64(value))
    # No need to compare == padding
    encoded_value.gsub("=", "") == value.chomp.gsub("=", "")
  end 
end


