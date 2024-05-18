class User < ApplicationRecord
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    before_create :generate_api_token

    private
    def generate_api_token
        self.api_token = SecureRandom.hex(32)
    end
end
