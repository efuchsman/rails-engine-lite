class Api::V1::MerchantsController < ApplicationController
  before_action :all_merchants,  only: [:index]

  def index
    render json: MerchantSerializer.new(@merchants)
  end

  def all_merchants
    @merchants = Merchant.all
  end
end
