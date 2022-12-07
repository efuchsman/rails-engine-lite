# frozen_string_literal: true

require 'rails_helper'

describe 'Items API [GET]' do
  describe 'GET /items' do
    describe 'When the records exist' do
      before :each do
        @merchant = create(:merchant)
        @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 75_000, merchant_id: @merchant.id)
        @item2 = Item.create!(name: 'name2', description: 'desc2', unit_price: 85_000, merchant_id: @merchant.id)
      end

      it 'returns a successful response' do
        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
      end

      it 'returns a status code 200' do
        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
      end

      it 'returns all items' do
        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data].count).to eq(2)
        expect(items[:data].first).to have_key(:id)
        expect(items[:data].first).to have_key(:type)
        expect(items[:data].first).to have_key(:attributes)
        expect(items[:data].class).to be Array
        expect(items[:data].first.class).to be Hash

        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)

        expect(items[:data][0][:attributes][:name].class).to be String
        expect(items[:data][0][:attributes][:description].class).to be String
        expect(items[:data][0][:attributes][:unit_price].class).to be Float
        expect(items[:data][0][:attributes][:merchant_id].class).to be Integer
      end
    end
  end

  describe 'GET /items/:id' do
    describe 'When the records exist' do
      before :each do
        @merchant = create(:merchant)
        @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 75_000, merchant_id: @merchant.id)
        @item2 = Item.create!(name: 'name2', description: 'desc2', unit_price: 85_000, merchant_id: @merchant.id)
      end

      it 'returns a successful response' do
        get "/api/v1/items/#{@item1.id}"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
      end

      it 'returns a status code 200' do
        get "/api/v1/items/#{@item1.id}"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
      end

      it 'returns an item' do
        get "/api/v1/items/#{@item1.id}"

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item.class).to be Hash
        expect(item).to have_key(:data)
        expect(item[:data].class).to be Hash

        expect(item[:data]).to have_key(:id)
        expect(item[:data]).to have_key(:type)
        expect(item[:data]).to have_key(:attributes)

        expect(item[:data][:id].class).to be String
        expect(item[:data][:type].class).to be String
        expect(item[:data][:attributes].class).to be Hash

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes]).to have_key(:merchant_id)

        expect(item[:data][:attributes][:name].class).to be String
        expect(item[:data][:attributes][:description].class).to be String
        expect(item[:data][:attributes][:unit_price].class).to be Float
        expect(item[:data][:attributes][:merchant_id].class).to be Integer
      end
    end

    describe 'When the record DNE' do
      it 'returns status code 404' do
        get '/api/v1/items/4'

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get '/api/v1/items/4'

        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'GET /items/:item_id/merchant' do
    describe 'When the records exist' do
      before :each do
        @merchant = create(:merchant)
        @item = Item.create!(name: 'name1', description: 'desc1', unit_price: 75_000, merchant_id: @merchant.id)
      end

      it 'returns a successful response' do
        get "/api/v1/items/#{@item.id}/merchant"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
      end

      it 'returns a status code 200' do
        get "/api/v1/items/#{@item.id}/merchant"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'When the record DNE' do
    it 'returns status code 404' do
      get '/api/v1/items/4/merchant'

      expect(response).to have_http_status(404)
    end

    it 'returns a not found message' do
      get '/api/v1/items/4'

      expect(response.body).to match(/Couldn't find Item/)
    end
  end
end
