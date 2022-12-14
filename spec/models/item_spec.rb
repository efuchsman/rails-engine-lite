# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
    it { should validate_presence_of :merchant_id }
    it { should validate_numericality_of(:merchant_id).is_greater_than(0) }
  end

  describe 'Class Methods' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 99.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc1', unit_price: 37.99, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'name3', description: 'desc1', unit_price: 84.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: 'name4', description: 'desc1', unit_price: 79.99, merchant_id: @merchant.id)
    end

    describe ' #find_items_by_name' do
      it 'returns all items with similar search name' do
        expect(Item.find_items_by_name('name').count).to eq(4)
      end
    end

    describe '#min_price' do
      it 'returns items above a minimum unit price threshold' do
        expect(Item.min_price(50)).to eq([@item1, @item3, @item4])
      end
    end

    describe '#max_price' do
      it 'returns items under a max price threshold' do
        expect(Item.max_price(50)).to eq([@item2])
      end
    end

    describe '#find_an_item_by_name' do
      it 'finds one item based off a given name param' do
        expect(Item.find_an_item_by_name('name')).to eq(@item1)
      end
    end

    describe '#min_price_one' do
      it 'finds one item within a price threshold in alphabetical order' do
        item5 = Item.create!(name: 'ame5', description: 'desc1', unit_price: 74.99, merchant_id: @merchant.id)
        expect(Item.min_price_one(50)).to eq(item5)
      end
    end

    describe '#max_price_one' do
      it 'finds one item within a price threshold in alphabetical order' do
        item5 = Item.create!(name: 'ame5', description: 'desc1', unit_price: 34.99, merchant_id: @merchant.id)

        expect(Item.max_price_one(50)).to eq(item5)
      end
    end

    describe "#min_and_max" do
      it 'finds one item within a price threshold in alphabetical order' do
        item5 = Item.create!(name: 'ame5', description: 'desc1', unit_price: 69.99, merchant_id: @merchant.id)

        expect(Item.min_and_max(60, 80)).to eq([@item4, item5])
      end
    end

    describe "#min_and_max_one" do
      it 'finds one item within a price threshold in alphabetical order' do
        item5 = Item.create!(name: 'ame5', description: 'desc1', unit_price: 69.99, merchant_id: @merchant.id)

        expect(Item.min_and_max_one(60, 80)).to eq(@item4)
      end
    end
  end
end
