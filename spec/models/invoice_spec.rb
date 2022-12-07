# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'Class Methods' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 74.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc2', unit_price: 79.99, merchant_id: @merchant.id)

      @invoice1 = Invoice.create
      @invoice2 = Invoice.create
      @invoice3 = Invoice.create

      @invoices = [@invoice1, @invoice2, @invoice3]

      @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, quantity: 2, unit_price: 74.99)
      @ii2 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item1.id, quantity: 3, unit_price: 74.99)
      @ii3 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item2.id, quantity: 3, unit_price: 79.99)
    end

    describe '#delete_invoices' do
      it 'Destroys an Invoice if that Invoices only item gets deleted' do
        # binding.pry
        @invoices.each(&:delete_invoice)

        expect(Invoice.all).to eq([@invoice1, @invoice2])
      end
    end
  end
end
