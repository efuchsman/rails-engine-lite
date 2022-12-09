# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items

  validates_presence_of :name

  def self.find_a_merchant_by_name(name_search)
    where('name ILIKE ?', "%#{name_search}%").first
  end

  def self.find_all_merchants_by_name(name_search)
    where('name ILIKE ?', "%#{name_search}%")
  end
end
