require 'rails_helper'

describe "Items API [DELETE]" do
  describe "DELETE '/items/:id" do
    it "can destroy an item" do
      merchant = create(:merchant)
      item1 = Item.create!(name: "name1", description: "desc1", unit_price: 74.99, merchant_id: merchant.id)

      expect(Item.count).to eq(1)

      expect{ delete "/api/v1/items/#{item1.id}" }.to change(Item, :count).by(-1)
      expect(response).to be_successful
      expect{Item.find(item1.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
