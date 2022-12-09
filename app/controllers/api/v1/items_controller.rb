# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        if params[:merchant_id]
          @merchant = Merchant.find(params[:merchant_id])
          @items = @merchant.items

          render json: ItemSerializer.new(@items)
        else
          render json: ItemSerializer.new(Item.all)
        end
      end

      def show
        if params[:merchant_id]
          @merchant = Merchant.find(params[:merchant_id])
          @item = @merchant.items.find(params[:id])

          render json: ItemSerializer.new(@item)
        else
          render json: ItemSerializer.new(Item.find(params[:id]))
        end
      end

      def create
        item = Item.new(item_params)

        if item.save
          render json: ItemSerializer.new(item), status: :created

        else
          render json: {
                   errors: item.errors,
                   error_codes: item.errors.keys.map { |f| "#{f.upcase}_ERROR" }
                 },
                 status: 422
        end
      end

      def update
        @item = Item.find(params[:id])
        if @item.update(item_params)
          render json: ItemSerializer.new(@item), status: 202
        else
          render status: 404
        end
      end

      def destroy
        item = Item.find(params[:id])
        item.invoices.delete_invoices
        render json: item.destroy
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
