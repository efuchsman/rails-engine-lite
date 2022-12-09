# frozen_string_literal: true

require 'rails_helper'

describe 'Merchants API [GET] requests' do
  describe 'GET /merchants' do
    describe 'when records exist' do
      before :each do
        create_list(:merchant, 3)
      end

      it 'returns a successful response' do
        get '/api/v1/merchants'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
      end

      it 'returns a status code 200' do
        get '/api/v1/merchants'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
      end

      it 'returns merchants' do
        get '/api/v1/merchants'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(3)
        expect(merchants.class).to be Hash
        expect(merchants[:data].class).to be Array
        expect(merchants[:data].first.class).to be Hash
      end
    end
  end

  describe 'GET /merchants/:id' do
    before :each do
      @merchants = create_list(:merchant, 3)
      @merchant1 = @merchants.first
    end

    describe 'when records exist' do
      it 'returns a successful response' do
        get "/api/v1/merchants/#{@merchant1.id}"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
      end

      it 'returns a status code 200' do
        get "/api/v1/merchants/#{@merchant1.id}"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
      end

      it 'returns a merchant' do
        get "/api/v1/merchants/#{@merchant1.id}"
        merchant1 = JSON.parse(response.body, symbolize_names: true)

        expect(merchant1.class).to be Hash
        expect(merchant1).to have_key(:data)
        expect(merchant1[:data].class).to be Hash
        expect(merchant1[:data]).to have_key(:id)
        expect(merchant1[:data]).to have_key(:type)
        expect(merchant1[:data]).to have_key(:attributes)
        expect(merchant1[:data][:attributes]).to have_key(:name)
        expect(merchant1[:data][:attributes][:name].class).to be String
      end
    end

    describe 'When the record DNE' do
      it 'returns status code 404' do
        get '/api/v1/merchants/4'

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get '/api/v1/merchants/4'

        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end
  end

  describe 'GET /merchants/:merchant_id/items' do
    describe 'when records exist' do
      before :each do
        @merchant = create(:merchant)
        @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 75_000, merchant_id: @merchant.id)
        @item2 = Item.create!(name: 'name2', description: 'desc2', unit_price: 85_000, merchant_id: @merchant.id)
      end

      it 'returns a successful response' do
        get "/api/v1/merchants/#{@merchant.id}/items"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
      end

      it 'returns a status code 200' do
        get "/api/v1/merchants/#{@merchant.id}/items"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
      end

      it "It returns a merchant's items" do
        get "/api/v1/merchants/#{@merchant.id}/items"

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)

        expect(items[:data][0]).to have_key(:id)
        expect(items[:data][0]).to have_key(:type)
        expect(items[:data][0]).to have_key(:attributes)

        expect(items[:data][0][:id].class).to be String
        expect(items[:data][0][:type].class).to be String

        expect(items[:data][0][:attributes].class).to be Hash
        expect(items[:data][0][:attributes]).to have_key(:name)
        expect(items[:data][0][:attributes]).to have_key(:description)
        expect(items[:data][0][:attributes]).to have_key(:unit_price)
        expect(items[:data][0][:attributes]).to have_key(:merchant_id)

        expect(items[:data][0][:attributes][:name].class).to be String
        expect(items[:data][0][:attributes][:description].class).to be String
        expect(items[:data][0][:attributes][:unit_price].class).to be Float
        expect(items[:data][0][:attributes][:merchant_id].class).to be Integer
      end
    end

    describe 'When the merchant id DNE' do
      it 'returns status code 404' do
        get '/api/v1/merchants/4/items'

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get '/api/v1/merchants/4/items'

        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end
  end

  describe 'GET /merchants/find?name=' do
    before :each do
      @merchant1 = Merchant.create!(name: 'Guard and Grace')
      @merchant2 = Merchant.create!(name: 'Buckhorn Exchange')
      @merchant3 = Merchant.create!(name: 'Sushi Den')
      @merchant4 = Merchant.create!(name: "Gaetano's")
      @merchant5 = Merchant.create!(name: 'Greenwich')
    end

    describe 'when records exist' do
      it 'returns a status code 200' do
        get '/api/v1/merchants/find?name=buck'

        JSON.parse(response.body, symbolize_names: true)
        # binding.pry
        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end

      it 'has readable attributes' do
        get '/api/v1/merchants/find?name=buck'

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant.class).to be Hash
        expect(merchant).to have_key(:data)

        expect(merchant[:data].class).to be Hash
        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data]).to have_key(:type)
        expect(merchant[:data]).to have_key(:attributes)

        expect(merchant[:data][:id].class).to be String
        expect(merchant[:data][:type].class).to be String
        expect(merchant[:data][:attributes].class).to be Hash

        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name].class).to be String
      end
    end

    describe 'When a name is provided but does not partially match anything in the DB' do
      it 'returns data as a an empty hash' do
        get '/api/v1/merchants/find?name=b45'

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant.class).to be Hash
        expect(merchant).to have_key(:data)
        expect(merchant[:data]).to eq({})
      end

      it 'returns status 400' do
        get '/api/v1/merchants/find?name=b45'

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)
      end
    end

    describe 'When no name is provided' do
      it 'returns an invalid search' do
        get '/api/v1/merchants/find?name='

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant.class).to be Hash
        expect(merchant).to have_key(:data)
        expect(merchant[:data]).to eq('Invalid Search')
      end

      it 'returns status 400' do
        get '/api/v1/merchants/find?name='

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)
      end
    end
  end

  describe "GET /merchants/find_all?name=" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Guard and Grace')
      @merchant2 = Merchant.create!(name: 'Buckhorn Exchange')
      @merchant3 = Merchant.create!(name: 'Sushi Den')
      @merchant4 = Merchant.create!(name: "Gaetano's")
      @merchant5 = Merchant.create!(name: 'Greenwich')
      @merchant6 = Merchant.create!(name: 'Name1')
      @merchant7 = Merchant.create!(name: 'Name2')
      @merchant8 = Merchant.create!(name: 'Name3')
    end

    describe 'when records exist' do
      it 'returns a status code 200' do
        get '/api/v1/merchants/find_all?name=name'

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end

      it "has readable attributes" do
        get '/api/v1/merchants/find_all?name=name'

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(3)
        expect(merchants.class).to be Hash
        expect(merchants[:data].class).to be Array
        expect(merchants[:data].first.class).to be Hash
        expect(merchants[:data].first).to have_key(:id)
        expect(merchants[:data].first).to have_key(:type)
        expect(merchants[:data].first).to have_key(:attributes)
        expect(merchants[:data].first[:attributes]).to have_key(:name)
        expect(merchants[:data].first[:attributes][:name].class).to be String
      end
    end

    describe "When there are no partial matches" do
      it "Returns status 400" do
        get '/api/v1/merchants/find_all?name=n5me'

        expect(response).to have_http_status(400)
      end

      it 'returns blank data' do
        get '/api/v1/merchants/find_all?name=n5me'

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants.class).to be Hash
        expect(merchants).to have_key(:data)
        expect(merchants[:data]).to eq([])
      end
    end

    describe "When no name is provided" do
      it 'returns invalid search' do
        get '/api/v1/merchants/find_all?name='

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants.class).to be Hash
        expect(merchants).to have_key(:data)
        expect(merchants[:data]).to eq('Invalid Search')
      end

      it "returns status 400" do
        get '/api/v1/merchants/find_all?name='

        expect(response).to have_http_status(400)
      end
    end
  end
end
