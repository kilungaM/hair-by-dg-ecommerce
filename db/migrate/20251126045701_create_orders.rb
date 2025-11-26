class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :status
      t.decimal :subtotal
      t.decimal :gst_amount
      t.decimal :pst_amount
      t.decimal :hst_amount
      t.decimal :grand_total

      t.timestamps
    end
  end
end
