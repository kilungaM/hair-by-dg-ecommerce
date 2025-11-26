class Province < ApplicationRecord
  has_many :customers
  validates :name, presence: true
  validates :gst, :pst, :hst, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    ["name", "gst", "pst", "hst", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customers"]
  end
end