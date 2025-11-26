class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy

  validates :status, presence: true
  validates :grand_total, numericality: { greater_than_or_equal_to: 0 }
end