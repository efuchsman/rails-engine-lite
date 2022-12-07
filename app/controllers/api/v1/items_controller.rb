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

  def show
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @item = @merchant.items.find(params[:id])

      render json: ItemSerializer.new(@item)
    else
      render json: ItemSerializer.new(Item.find(params[:id]))
    end
  end

  def create
    item = Item.new(item_params)

    if item.save
    render json: ItemSerializer.new(item), status: :created

    else
      render json: {
        errors: item.errors,
        error_codes: item.errors.keys.map { |f| "#{f.upcase}" + "_ERROR" }
      },
      status: 422
    end
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params)), status: 202
  end

  def destroy
    item = Item.find(params[:id])
    item.invoices.map(&:destroy_invoice)
    render json: item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
