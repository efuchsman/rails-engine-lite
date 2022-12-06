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
end
