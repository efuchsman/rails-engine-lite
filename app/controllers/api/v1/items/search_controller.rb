# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def index
          if name_search?
            find_items_params_name
            if @items_name.nil? || @items_name.empty?
              render_blank_data
            else
              render_json(@items_name)
            end
          elsif positive_min_price_search?
            find_items_params_min_price
            if @items_min_price.nil?
              render_blank_data
            else
              render_json(@items_min_price)
            end
          elsif negative_min_price_search?
            render_blank_error
          elsif positive_max_price_search?
            find_items_params_max_price
            if @items_max_price.nil?
              render_blank_data
            else
              render_json(@items_max_price)
            end
          elsif negative_max_price_search?
            render_blank_error
          else
            render_invalid
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

        private

        def name_search?
          params[:name].present? && !params[:max_price].present? && !params[:min_price].present?
        end

        def positive_min_price_search?
          params[:min_price].present? && !params[:name].present? && !params[:max_price].present? && params[:min_price].to_f.positive?
        end

        def negative_min_price_search?
          params[:min_price].present? && !params[:name].present? && !params[:max_price].present? && params[:min_price].to_f.negative?
        end

        def positive_max_price_search?
          params[:max_price].present? && !params[:name].present? && !params[:min_price].present? && params[:max_price].to_f.positive?
        end

        def negative_max_price_search?
          !params[:min_price].present? && !params[:name].present? && params[:max_price].present? && params[:max_price].to_f.negative?
        end

        def render_json(items)
          render json: ItemSerializer.new(items)
        end

        def render_invalid
          render json: { data: 'Invalid Search' }, status: 400
        end

        def render_blank_data
          render json: { data: {} }, status: 404
        end

        def render_blank_error
          render json: { errors: {} }, status: 400
        end

        def find_items_params_name
          @items_name = Item.find_items_by_name(params[:name])
        end

        def find_items_params_min_price
          @items_min_price = Item.min_price(params[:min_price])
        end

        def find_items_params_max_price
          @items_max_price = Item.max_price(params[:max_price])
        end
      end
    end
  end
end
