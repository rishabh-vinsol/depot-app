class RatingsController < ApplicationController
  before_action :set_rating, only: %i[ show edit update destroy ]

  def create
    @rating = Rating.find_or_initialize_by(rating_params)
    @rating.points = params[:points]

    if @rating.save
      render json: { success: true, average_rating: @rating.product.average_rating, span_id: "#rating#{@rating.product_id}" }
    else
      render json: { success: false, errors: @rating.errors.full_messages }
    end
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.permit(:user_id, :product_id)
  end
end
