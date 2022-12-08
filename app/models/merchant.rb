# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items

  validates_presence_of :name


  def self.find_a_merchant_by_name(name_search)
    where('name ILIKE ?', "%#{name_search}%").first

  # sql = ("
  #    SELECT * FROM merchants
  #     WHERE name ilike '%#{name_search}%'
  #   ")
  #   result = ActiveRecord::Base.connection.execute(sql).values.first
  end
end
