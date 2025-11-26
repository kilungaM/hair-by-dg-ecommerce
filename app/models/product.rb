class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  scope :on_sale, -> { where(on_sale: true) }
  scope :recent, -> { where('created_at >= ?', 3.days.ago) }
  scope :recently_updated, -> { where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago) }

  def self.search_by_keyword_and_category(keyword, category_id)
    products = all
    products = products.where(category_id: category_id) if category_id.present?
    products = products.where('name LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%") if keyword.present?
    products
  end
end