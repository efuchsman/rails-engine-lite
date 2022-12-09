# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def index
          build_the_index
        end

        def show
          build_show_page
        end

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

        def positive_min_and_max_search?
          params[:max_price].present? && !params[:name].present? && params[:min_price].present? && params[:max_price].to_f.positive? && params[:min_price].to_f.positive?
        end

        def render_json(items)
          render json: ItemSerializer.new(items)
        end

        def render_invalid
          render json: { data: 'Invalid Search' }, status: 400
        end

        def render_blank_hash_data
          render json: { data: {} }, status: 404
        end

        def render_blank_array_data
          render json: { data: [] }, status: 404
        end

        def render_blank_error
          render json: { errors: {} }, status: 400
        end

        def items_by_name
          Item.find_items_by_name(params[:name])
        end

        def items_min_price
          Item.min_price(params[:min_price])
        end

        def items_max_price
          Item.max_price(params[:max_price])
        end

        def item_by_name
          Item.find_an_item_by_name(params[:name])
        end

        def item_min_price
          Item.min_price_one(params[:min_price])
        end

        def item_max_price
          Item.max_price_one(params[:max_price])
        end

        def items_min_and_max
          Item.min_and_max(params[:min_price], params[:max_price])
        end

        def item_min_and_max
          Item.min_and_max_one(params[:min_price], params[:max_price])
        end

        def build_the_index
          if name_search?
            items_by_name
            if items_by_name.nil? || items_by_name.empty?
              render_blank_array_data
            else
              render_json(items_by_name)
            end
          elsif positive_min_price_search?
            items_min_price
            if items_min_price.nil? || items_min_price.empty?
              render_blank_array_data
            else
              render_json(items_min_price)
            end
          elsif negative_min_price_search?
            render_blank_error
          elsif positive_max_price_search?
            items_max_price
            if items_max_price.nil? || items_max_price.empty?
              render_blank_array_data
            else
              render_json(items_max_price)
            end
          elsif negative_max_price_search?
            render_blank_error

          elsif positive_min_and_max_search?
            items_min_and_max
            if items_min_and_max.nil? || items_min_and_max.empty?
              render_blank_array_data
            else
              render_json(items_min_and_max)
            end
          else
            render_invalid
          end
        end

        def build_show_page
          if name_search?
            item_by_name
            if item_by_name.nil?
              render_blank_hash_data
            else
              render_json(item_by_name)
            end
          elsif positive_min_price_search?
            item_min_price
            if item_min_price.nil?
              render_blank_hash_data
            else
              render_json(item_min_price)
            end
          elsif negative_min_price_search?
            render_blank_error
          elsif positive_max_price_search?
            item_max_price
            if item_max_price.nil?
              render_blank_hash_data
            else
              render_json(item_max_price)
            end
          elsif negative_max_price_search?
            render_blank_error
          elsif positive_min_and_max_search?
            item_min_and_max
            if item_min_and_max.nil?
              render json: { data: {} }, status: 400
            else
              render_json(item_min_and_max)
            end
          else
            render_invalid
          end
        end
      end
    end
  end
end
