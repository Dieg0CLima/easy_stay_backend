class Api::V1::AuthController < ApplicationController
  SECRET_KEY = Rails.application.secret_key_base

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      # Corrigido para passar o user.id
      token = encode_token({ user_id: user.id })
      render json: { token: }, status: :ok
    else
      render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
    end
  end

  def auto_login
    token = request.headers['Authorization']
    decoded_token = decoded_token(token)

    if decoded_token
      user_id = decoded_token[0]['user_id']
      user = User.find_by(id: user_id)

      if user
        render json: { user: }, status: :ok
      else
        render json: { error: 'Usuário não encontrado' }, status: :unauthorized
      end
    else
      render json: { error: 'Token Inválido' }, status: :unauthorized
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decoded_token(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
  rescue JWT::DecodeError
    nil
  end
end
