class Customer < ApplicationRecord
  belongs_to :province
  has_many :orders

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :city, presence: true
  validates :province_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["email", "address", "city", "province_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["province", "orders"]
  end
end