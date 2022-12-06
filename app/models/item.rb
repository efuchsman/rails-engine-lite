class Item < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_numericality_of :unit_price, greater_than: 0
  validates_presence_of :merchant_id
  validates_numericality_of :merchant_id, greater_than: 0
end
