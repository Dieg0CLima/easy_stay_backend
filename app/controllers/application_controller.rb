class ApplicationController < ActionController::API
  SECRET_KEY = Rails.application.secret_key_base

  def authorize
    token = request.headers['Authorization']
    decoded_token = decode_token(token)

    if decoded_token
      user_id = decoded_token[0]['user_id']
      @current_user = User.find_by(id: user_id)

      render json: { error: 'Usuário não autorizado' }, status: :unauthorized unless @current_user
    else
      render json: { error: 'Token Inválido' }, status: :unauthorized
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
  rescue JWT::DecodeError
    nil
  end
end
