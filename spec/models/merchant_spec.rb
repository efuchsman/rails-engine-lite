require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
  end

  describe "Class Methods" do

    before :each do
      @merchant1 = Merchant.create!(name: "Guard and Grace")
      @merchant2 = Merchant.create!(name: "Buckhorn Exchange")
      @merchant3 = Merchant.create!(name: "Sushi Den")
      @merchant4 = Merchant.create!(name: "Gaetano's")
      @merchant5 = Merchant.create!(name: "Greenwich")
    end

    describe "#find_a_merchant_by_name" do
      it "finds a merchant by a given name" do

        expect(Merchant.find_a_merchant_by_name("gaetano")).to eq(@merchant4)
      end
    end
  end
end
