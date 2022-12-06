require 'rails_helper'

describe "Merchants API [GET] requests" do
  describe "GET /merchants" do
    describe "when records exist" do
      before :each do
        create_list(:merchant, 3)
      end

      it "returns a successful response" do

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

  describe "GET /merchants/:id" do
    before :each do
      @merchants = create_list(:merchant, 3)
      @merchant1 = @merchants.first
    end

    describe "when records exist" do
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
      end
    end

    describe 'When the record DNE' do
      it 'returns status code 404' do
        get "/api/v1/merchants/4"

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get "/api/v1/merchants/4"

        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end
  end

  describe "GET /merchants/:merchant_id/items" do
    describe "when records exist" do
      before :each do
        @merchant = create(:merchant)
        @item1 = Item.create!(name: "name1", description: "desc1", unit_price: 75000, merchant_id: @merchant.id)
        @item2 = Item.create!(name: "name2", description: "desc2", unit_price: 85000, merchant_id: @merchant.id)
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

        expect(items[:data][0][:attributes]).to have_key(:name)
        expect(items[:data][0][:attributes]).to have_key(:description)
        expect(items[:data][0][:attributes]).to have_key(:unit_price)
        expect(items[:data][0][:attributes]).to have_key(:merchant_id)
      end
    end
  end
end
