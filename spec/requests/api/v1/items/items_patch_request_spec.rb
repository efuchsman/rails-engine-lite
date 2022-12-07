require 'rails_helper'

describe "Items API [PATCH]" do
  describe "PATCH '/items/:id'" do
    describe "When the request is valid" do
      it "expects response to be successful" do
        merchant = create(:merchant)
        item = Item.create!(name: "name1", description: "desc1", unit_price: 100.99, merchant_id: merchant.id )
        id = item.id
        updated_params = { name: "value1" }
        headers = { "CONTENT_TYPE" => "application/json" }

        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: updated_params })
        updated_item = Item.find_by(id: id)

        expect(response).to be_successful
      end
    end
  end
end
