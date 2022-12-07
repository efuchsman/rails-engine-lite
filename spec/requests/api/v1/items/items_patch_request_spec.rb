require 'rails_helper'

describe "Items API [PATCH]" do
  describe "PATCH '/items/:id'" do
    describe "When the request is valid" do
      before :each do
        @merchant = create(:merchant)
        @item = Item.create!(name: "name1", description: "desc1", unit_price: 100.99, merchant_id: @merchant.id )
        @id = @item.id
        @updated_params = { name: "value1" }
        @headers = { "CONTENT_TYPE" => "application/json" }

        patch "/api/v1/items/#{@id}", headers: @headers, params: JSON.generate({ item: @updated_params })
        @updated_item = Item.find_by(id: @id)
      end

      it "expects response to be successful" do

        expect(response).to be_successful
      end

      it 'returns status code 202' do

        expect(response).to have_http_status(202)
      end

      it 'has a updated attribute' do

        expect(@updated_item.name).to_not eq(@item.name)
        expect(@updated_item.id).to eq(@item.id)
      end
    end

    describe "If the item DNE" do
      before :each do
        @merchant = create(:merchant)
        @item = Item.create!(name: "name1", description: "desc1", unit_price: 100.99, merchant_id: @merchant.id )
        @id = @item.id
        @updated_params = { name: "value1" }
        @headers = { "CONTENT_TYPE" => "application/json" }

        patch "/api/v1/items/22", headers: @headers, params: JSON.generate({ item: @updated_params })
        @updated_item = Item.find_by(id: @id)
      end

      it 'returns status code 404' do

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do

        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end
end
