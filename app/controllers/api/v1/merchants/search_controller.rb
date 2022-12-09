# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def index
          if params[:name].present?
            merchants = find_all_merchants_by_name
            if merchants.nil? || merchants.blank?
              render_blank_array_data
            else
              render_json(merchants)
            end
          else
            invalid_search
          end
        end

        def show
          if params[:name].present?
            merchant = find_a_merchant_by_name
            if merchant.nil?
              render_blank_hash_data
            else
              render_json(merchant)
            end
          else
            invalid_search
          end
        end

        private

        def render_json(input)
          render json: MerchantSerializer.new(input)
        end

        def invalid_search
          render json: { data: 'Invalid Search' }, status: 400
        end

        def render_blank_hash_data
          render json: { data: {} }, status: 400
        end

        def render_blank_array_data
          render json: { data: [] }, status: 400
        end

        def find_all_merchants_by_name
          Merchant.find_all_merchants_by_name(params[:name])
        end

        def find_a_merchant_by_name
          Merchant.find_a_merchant_by_name(params[:name])
        end
      end
    end
  end
end
