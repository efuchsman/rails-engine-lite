# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController

        def index
          if params[:name].present?
            merchants = Merchant.find_all_merchants_by_name(params[:name])
            if merchants.nil?
              render json: { data: {} }, status: 400
            else
              render json: MerchantSerializer.new(merchants)
            end
          else
            render json: { data: 'Invalid Search' }, status: 400
          end
        end

        def show
          if params[:name].present?
            merchant = Merchant.find_a_merchant_by_name(params[:name])
            if merchant.nil?
              render json: { data: {} }, status: 400
            else
              render json: MerchantSerializer.new(merchant)
            end
          else
            render json: { data: 'Invalid Search' }, status: 400
          end
        end
      end
    end
  end
end
