# frozen_string_literal: true

class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def delete_invoice
    # .select("invoices.*, count(invoice_items) as item_count")
    # .where("invoices.id = invoice_items.invoice_id")
    # .having("count(invoice_items) = 0")
    # .group(:id)
    # .destroy_all
    destroy if items.count.zero?
  end
end
