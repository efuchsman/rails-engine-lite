class Api::V1::ItemsController < ApplicationController

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items

      render json: ItemSerializer.new(@items)
    else
      render json: ItemSerializer.new(Item.all)
    end
  end
end
