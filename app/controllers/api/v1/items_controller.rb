# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        if params[:merchant_id]
          find_merchant
          render_serialized_json(merchant_items)
        else
          render_serialized_json(find_items)
        end
      end

      def show
        if params[:merchant_id]
          find_merchant
          render_serialized_json(merchant_item)
        else
          render_serialized_json(find_item)
        end
      end

      def create
        item = Item.new(item_params)
        if item.save
          render_created_serialized_json(item)
        else
          error_map(item)
        end
      end

      def update
        find_item
        if find_item.update(item_params)
          render json: ItemSerializer.new(find_item), status: 202
        else
          render status: 404
        end
      end

      def destroy
        find_item
        render json: find_item.destroy
        Invoice.delete_invoices
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end

      def find_merchant
        @merchant = Merchant.find(params[:merchant_id])
      end

      def merchant_items
        @merchant.items
      end

      def merchant_item
        merchant_items.find(params[:id])
      end

      def find_items
        Item.all
      end

      def find_item
        Item.find(params[:id])
      end

      def render_serialized_json(arg)
        render json: ItemSerializer.new(arg)
      end

      def render_created_serialized_json(arg)
        render json: ItemSerializer.new(arg), status: :created
      end

      def error_map(arg)
        render json: {
                 errors: arg.errors,
                 error_codes: arg.errors.keys.map { |f| "#{f.upcase}_ERROR" }
               },
               status: 422
      end
    end
  end
end
