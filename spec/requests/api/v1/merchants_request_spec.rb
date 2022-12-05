require 'rails_helper'

describe "Merchants API" do
  describe "GET /merchants" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)
      get '/api/v1/merchants'

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchants[:data].count).to eq(3)
      expect(merchants.class).to be Hash
      expect(merchants[:data].class).to be Array
      expect(merchants[:data].first.class).to be Hash

    end
  end
end
