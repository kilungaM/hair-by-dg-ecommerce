class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true, inclusion: { in: %w[pending paid shipped] }
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :grand_total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    ["customer_id", "status", "subtotal", "gst_amount", "pst_amount", "hst_amount", "grand_total", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items", "products"]
  end
end