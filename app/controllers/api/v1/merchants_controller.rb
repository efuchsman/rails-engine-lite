class Api::V1::MerchantsController < ApplicationController
  before_action :all_merchants,  only: [:index]
  before_action :one_merchant, only: [:show]
  def index
    render json: MerchantSerializer.new(@merchants)
  end

  def show
    render json: MerchantSerializer.new(@merchant)
  end

  def all_merchants
    @merchants = Merchant.all
  end

  def one_merchant
    @merchant = Merchant.find(params[:id])
  end
end
