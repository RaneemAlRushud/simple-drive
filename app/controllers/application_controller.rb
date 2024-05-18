class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    private
    def authenticate
        authenticate_with_http_token do |token, options|
            @current_user = User.find_by(api_token: token)
        end

        unless @current_user.present?
            return render json: {
                message: "Unauthorized access"
            }, status: 401
        end
    end
end
