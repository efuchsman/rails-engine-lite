# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_numericality_of :unit_price, greater_than: 0
  validates_presence_of :merchant_id
  validates_numericality_of :merchant_id, greater_than: 0

  def self.find_items_by_name(name_search)
    where('name ILIKE ?', "%#{name_search}%")
  end

  def self.find_an_item_by_name(name_search)
    where('name ILIKE ?', "%#{name_search}%").first
  end

  def self.min_price(num)
    where("unit_price >= #{num}")
  end

  def self.max_price(num)
    where("unit_price <= #{num}")
  end

  def self.min_price_one(num)
    where("unit_price >= #{num}")
      .order(:name)
      .first
  end

  def self.max_price_one(num)
    where("unit_price <= #{num}")
      .order(:name)
      .first
  end

  def self.min_and_max(min, max)
    where("unit_price >= #{min}")
    .where("unit_price <= #{max}")
  end

  def self.min_and_max_one(min, max)
    where("unit_price >= #{min}")
    .where("unit_price <= #{max}")
    .first
  end
end
