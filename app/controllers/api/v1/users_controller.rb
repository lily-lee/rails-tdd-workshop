class Api::V1::UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    render json: @user
  end

  def create
    user = User.new user_params
    # binding.pry
    if user.save
      render json: user, status: 201
    else
      # binding.pry
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = User.find_by(id: params[:id])
    if user.update user_params
      render json: user, status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    user = User.find_by_id(params[:id])
    if user.blank?
      render json: { errors: "not found" }, status: 404
    end

    if user.destroy
      render json: {}, status: 204
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_conformation)
    end
end
