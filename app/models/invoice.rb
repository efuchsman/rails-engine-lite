# frozen_string_literal: true

class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.delete_invoices
    includes(:invoice_items)
      .where(invoice_items: { id: nil })
      .destroy_all
  end
end
