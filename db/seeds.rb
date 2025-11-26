# Clear existing data
puts "Clearing existing data..."
OrderItem.destroy_all
Order.destroy_all
Customer.destroy_all
Product.destroy_all
Category.destroy_all
Province.destroy_all
AdminUser.destroy_all
PageContent.destroy_all

# Create Admin User
puts "Creating admin user..."
AdminUser.create!(email: 'admin@hairbydg.com', password: 'password', password_confirmation: 'password')

# Create Provinces with correct tax rates
puts "Creating provinces..."
provinces_data = [
  { name: 'Alberta', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'British Columbia', gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: 'Manitoba', gst: 5.0, pst: 7.0, hst: 0.0 },
  { name: 'New Brunswick', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Newfoundland and Labrador', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Northwest Territories', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'Nova Scotia', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Nunavut', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'Ontario', gst: 0.0, pst: 0.0, hst: 13.0 },
  { name: 'Prince Edward Island', gst: 0.0, pst: 0.0, hst: 15.0 },
  { name: 'Quebec', gst: 5.0, pst: 9.975, hst: 0.0 },
  { name: 'Saskatchewan', gst: 5.0, pst: 6.0, hst: 0.0 },
  { name: 'Yukon', gst: 5.0, pst: 0.0, hst: 0.0 }
]

provinces_data.each { |p| Province.create!(p) }

# Create Categories
puts "Creating categories..."
categories = {
  hair_care: Category.create!(name: 'Hair Care'),
  beard_care: Category.create!(name: 'Beard Care'),
  skincare: Category.create!(name: 'Skincare'),
  accessories: Category.create!(name: 'Accessories')
}
# Import products from CSV
puts "Importing products from CSV..."
require 'csv'

csv_file = Rails.root.join('db', 'products.csv')
if File.exist?(csv_file)
  CSV.foreach(csv_file, headers: true) do |row|
    category = Category.find_by(name: row['category'])
    if category
      Product.create!(
        name: row['name'],
        description: row['description'],
        price: row['price'].to_f,
        stock: row['stock'].to_i,
        on_sale: row['on_sale'] == 'true',
        category: category
      )
    end
  end
  puts "CSV products imported successfully!"
end

# Create Products
puts "Creating products..."
products_data = [
  { name: 'Silk Hair Bonnet', description: 'Premium silk bonnet for hair protection during sleep. Prevents breakage and maintains hairstyles overnight.', price: 24.99, stock: 50, category: categories[:accessories], on_sale: true },
  { name: 'Satin Hair Bonnet', description: 'Soft satin bonnet, affordable alternative to silk. Great for all hair types and textures.', price: 14.99, stock: 75, category: categories[:accessories], on_sale: false },
  { name: 'Beard Growth Cream', description: 'Promotes fuller, healthier beard growth with natural ingredients. Apply daily for best results.', price: 29.99, stock: 40, category: categories[:beard_care], on_sale: false },
  { name: 'Organic Shampoo', description: 'Sulfate-free, plant-based shampoo for natural hair. Gentle cleansing without stripping moisture.', price: 18.99, stock: 100, category: categories[:hair_care], on_sale: true },
  { name: 'Organic Conditioner', description: 'Deep conditioning treatment for dry, damaged hair. Restores shine and manageability.', price: 19.99, stock: 95, category: categories[:hair_care], on_sale: false },
  { name: 'Moisturizing Body Lotion', description: 'Imported organic body lotion with shea butter. Hydrates and nourishes all skin types.', price: 22.99, stock: 60, category: categories[:skincare], on_sale: true },
  { name: 'Hair Oil - Argan', description: 'Pure argan oil for scalp nourishment and styling. Adds shine and reduces frizz.', price: 26.99, stock: 45, category: categories[:hair_care], on_sale: false },
  { name: 'Hair Oil - Coconut', description: 'Natural coconut oil for deep conditioning. Perfect for pre-wash treatments.', price: 15.99, stock: 80, category: categories[:hair_care], on_sale: false },
  { name: 'Beard Oil', description: 'Conditioning beard oil with essential oils. Softens and tames unruly beards.', price: 24.99, stock: 55, category: categories[:beard_care], on_sale: false },
  { name: 'Hair Serum - Shine Boost', description: 'Lightweight serum for instant shine and smoothness. Non-greasy formula.', price: 21.99, stock: 70, category: categories[:hair_care], on_sale: true },
  { name: 'Leave-In Conditioner', description: 'Daily leave-in treatment for detangling and moisture. Works on all hair types.', price: 17.99, stock: 85, category: categories[:hair_care], on_sale: false },
  { name: 'Edge Control Gel', description: 'Strong hold edge control for sleek styles. Water-based, flake-free formula.', price: 12.99, stock: 90, category: categories[:hair_care], on_sale: false }
]

products_data.each { |p| Product.create!(p) }

puts "Seed data created successfully!"
puts "Admin login: admin@hairbydg.com / password"

# Create Page Content
puts "Creating page content..."
PageContent.create!(
  title: 'About Hair by DG',
  slug: 'about',
  content: "Hair by DG is a Winnipeg-based salon that has been in business for five years. We offer professional hairstyling and grooming services for women, men, and children.\n\nOur team of 12 skilled stylists specializes in braiding, loc maintenance, haircuts, coloring, and extensions.\n\nOur mission is to help clients embrace and care for their natural hair textures while providing premium beauty services in a welcoming and inclusive environment."
)

PageContent.create!(
  title: 'Contact Us',
  slug: 'contact',
  content: "Get in touch with Hair by DG!\n\nLocation: Winnipeg, Manitoba\nEmail: info@hairbydg.com\nPhone: (204) 555-0123\n\nBusiness Hours:\nMonday - Friday: 9am - 8pm\nSaturday: 9am - 6pm\nSunday: 10am - 5pm"
)

puts "Page content created!"