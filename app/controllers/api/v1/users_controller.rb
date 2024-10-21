class Api::V1::UsersController < ApplicationController
  before_action :authorize, except: [:create]
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    if @user
      render json: @user
    else
      render json: { error: 'Usuário não encontrado' }, status: :not_found
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessanel_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessanel_entity
    end
  end

  def destroy
    if @user.destroy
      render json: { message: 'Usuário deletado com sucesso' }, status: :ok
    else
      render json: { error: 'Falha ao deletar usuário' }, status: :unprocessanel_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
