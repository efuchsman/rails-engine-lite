# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
  end

  describe 'Class Methods' do
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

    describe '#find_a_merchant_by_name' do
      it 'finds a merchant by a given name' do
        expect(Merchant.find_a_merchant_by_name('gaetano')).to eq(@merchant4)
      end
    end

    describe "Find_all_merchants_by_name" do
      it "finds all merchants that partially match a name param" do
        expect(Merchant.find_all_merchants_by_name("name")).to eq([@merchant6, @merchant7, @merchant8])
      end
    end
  end
end
