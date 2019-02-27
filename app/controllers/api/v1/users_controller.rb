class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]

  def show
    @user = User.find params[:id]
    render json: UserSerializer.new(@user)
  end

  def create
    user = User.new user_params
    # binding.pry
    if user.save
      render json: UserSerializer.new(user), status: 201
    else
      # binding.pry
      render json: { errors: ErrorSerializer.new(user).serialized_json }, status: 422
    end
  end

  def update
    user = current_user
    if user.blank?
      return render json: { errors: "not found" }, status: 404
    end

    if user.update user_params
      render json: UserSerializer.new(user), status: 200
    else
      render json: { errors: ErrorSerializer.new(user).serialized_json }, status: 422
    end
  end

  def destroy
    user = current_user
    if user.destroy
      head 204
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_conformation)
    end
end
