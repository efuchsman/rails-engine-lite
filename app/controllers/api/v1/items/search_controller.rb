# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def index
          if params[:name].present? && !params[:max_price].present? && !params[:min_price].present?
            items = Item.find_items_by_name(params[:name])
            # binding.pry
            if items.nil? || items.empty?
              render json: { data: {} }, :status => 404

            else
              render json: ItemSerializer.new(items)
            end

          elsif params[:min_price].present? && !params[:name].present? && !params[:max_price].present? && params[:min_price].to_f.positive?
            # binding.pry
            items = Item.min_price(params[:min_price])
            if items.nil?
              render json: { data: {} }, status: 400
            else
              render json: ItemSerializer.new(items)
            end

          elsif params[:min_price].present? && !params[:name].present? && !params[:max_price].present? && params[:min_price].to_f.negative?
            render json: { errors: {} }, status: 400

          elsif params[:max_price].present? && !params[:name].present? && !params[:min_price].present? && params[:max_price].to_f.positive?
            items = Item.max_price(params[:max_price])
            if items.nil?
              render json: { data: {} }, status: 400
            else
              render json: ItemSerializer.new(items)
            end

          elsif !params[:min_price].present? && !params[:name].present? && params[:max_price].present? && params[:max_price].to_f.negative?
            render json: { errors: {} }, status: 400

          else
            render json: { data: 'Invalid Search' }, status: 400
          end
        end

        # def show
        #   if params[:min_price].present?
        #     item = Item.min_price(params[:min_price])
        #     if item.nil?
        #     render json: { data: {  } }
        #     else
        #       render json: ItemSerializer.new(item)
        #     end
        #   else
        #     render json: ItemSerializer.new(item)
        #   end
        # end
      end
    end
  end
end
