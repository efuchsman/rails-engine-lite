class Api::V1::Merchants::SearchController < ApplicationController

  def show
    if params[:name].present?
      merchant = Merchant.find_a_merchant_by_name(params[:name])
      if merchant.nil?
      render json: { data: {  } }
      else
        render json: MerchantSerializer.new(merchant)
      end
    else
      render :json =>  { data: "Invalid Search" }, status: 404
    end
  end
end
