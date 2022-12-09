# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render_json(all_merchants)
      end

      def show
        if params[:item_id]
          find_item
          @merchant = find_item.merchant
        else
          @merchant = Merchant.find(params[:id])
        end
        render_json(@merchant)
      end

      private

      def all_merchants
        Merchant.all
      end

      def find_item
        Item.find(params[:item_id])
      end

      def render_json(arg)
        render json: MerchantSerializer.new(arg)
      end
    end
  end
end
