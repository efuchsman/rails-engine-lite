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
end
