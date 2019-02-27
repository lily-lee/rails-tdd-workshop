class Api::V1::ToysController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update, :delete]

  def index
    @toys = Toy.search_by_params toy_search_params
    render json: ToySerializer.new(@toys)
  end

  def show
    @toy = Toy.find params[:id]
    render json: ToySerializer.new(@toy)
  end

  def create
    toy = current_user.toys.new toy_params
    if toy.save
      render json: ToySerializer.new(toy), status: 201
    else
      render json: { errors: ErrorSerializer.new(toy).serialized_json }, status: 422
    end
  end

  def update
    toy = current_user.toys.find params[:id]
    if toy.update toy_params
      render json: ToySerializer.new(toy), status: 200
    else
      render json: { errors: ErrorSerializer.new(toy).serialized_json }, status: 422
    end
  end

  def destroy
    toy = current_user.toys.find params[:id]
    if toy.destroy
      head 204
    else
      render json: { errors: ErrorSerializer.new(toy).serialized_json }, status: 422
    end
  end

  private

    def toy_params
      params.require(:toy).permit(:user_id, :published, :title, :price)
    end

    def toy_search_params
      params.require(:search_param).permit(:keyword, :max_price, :min_price, :desc_order)
    end
end
