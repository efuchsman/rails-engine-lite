# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      before_action :all_merchants, only: [:index]

      def index
        render json: MerchantSerializer.new(@merchants)
      end

      def show
        if params[:item_id]
          @item = Item.find(params[:item_id])
          @merchant = @item.merchant
        else
          @merchant = Merchant.find(params[:id])
        end
        render json: MerchantSerializer.new(@merchant)
      end

      def all_merchants
        @merchants = Merchant.all
      end
    end
  end
end
