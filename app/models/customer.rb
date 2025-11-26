class Customer < ApplicationRecord
  belongs_to :province
  has_many :orders

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :province_id, presence: true
end