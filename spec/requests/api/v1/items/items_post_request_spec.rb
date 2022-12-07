# frozen_string_literal: true

require 'rails_helper'

describe 'Items API [POST]' do
  before :each do
    @merchant = create(:merchant)

    @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 75_000, merchant_id: @merchant.id)
    @item2 = Item.create!(name: 'name2', description: 'desc2', unit_price: 85_000, merchant_id: @merchant.id)

    @item_params = {
      name: 'value1',
      description: 'value2',
      unit_price: 100.99,
      merchant_id: @merchant.id
    }
  end

  describe 'POST /items' do
    describe 'When the request is valid' do
      it 'expects response to be successful' do
        post '/api/v1/items', params: { item: @item_params }
        item = Item.last

        expect(response).to be_successful
      end

      it 'returns a status code 201' do
        post '/api/v1/items', params: { item: @item_params }
        item = Item.last

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(201)
      end

      it 'has readable params' do
        post '/api/v1/items', params: { item: @item_params }

        item = Item.last

        get '/api/v1/items'
        updated_items = JSON.parse(response.body, symbolize_names: true)

        expect(updated_items[:data].last[:id].to_i).to eq(item.id)
        expect(updated_items[:data].last[:attributes][:name]).to eq('value1')
        expect(updated_items[:data].last[:attributes][:description]).to eq('value2')
        expect(updated_items[:data].last[:attributes][:unit_price]).to eq(100.99)
      end
    end

    describe 'when the request is invlaid' do
      it 'returns status code 422' do
        item1_params = {
          description: 'value2',
          unit_price: 100.99,
          merchant_id: @merchant.id
        }
        post '/api/v1/items', params: { item: item1_params }
        # binding.pry
        expect(response).to have_http_status(422)
      end

      describe 'When :name is blank' do
        it 'Returns a name error' do
          item1_params = {
            description: 'value2',
            unit_price: 100.99,
            merchant_id: @merchant.id
          }
          post '/api/v1/items', params: { item: item1_params }

          expect(response.body).to match(/NAME_ERROR/)
        end
      end

      describe 'When :description is blank' do
        it 'Returns a description error' do
          item1_params = {
            name: 'value2',
            unit_price: 100.99,
            merchant_id: @merchant.id
          }
          post '/api/v1/items', params: { item: item1_params }

          expect(response.body).to match(/DESCRIPTION_ERROR/)
        end
      end

      describe 'When :unit_price is blank' do
        it 'Returns a unit_price error' do
          item1_params = {
            name: 'value1',
            description: 'value2',
            merchant_id: @merchant.id
          }
          post '/api/v1/items', params: { item: item1_params }

          expect(response.body).to match(/UNIT_PRICE_ERROR/)
        end
      end

      describe 'When :merchant_id is blank' do
        it 'Returns a merchant_id error' do
          item1_params = {
            name: 'value1',
            description: 'value2',
            unit_price: 100.99
          }
          post '/api/v1/items', params: { item: item1_params }

          expect(response.body).to match(/MERCHANT_ID_ERROR/)
        end
      end

      describe 'When multiple params are blank' do
        it 'Returns multiple errors' do
          item1_params = {
            description: 'value2',
            unit_price: 100.99
          }
          post '/api/v1/items', params: { item: item1_params }

          expect(response.body).to match('["NAME_ERROR","MERCHANT_ID_ERROR"]')
        end
      end
    end
  end
end
