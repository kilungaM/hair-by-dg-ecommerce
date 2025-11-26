ActiveAdmin.register Order do
  permit_params :customer_id, :status, :subtotal, :gst_amount, :pst_amount, :hst_amount, :grand_total

  index do
    selectable_column
    id_column
    column :customer
    column :status do |order|
      status_tag order.status
    end
    column :subtotal do |order|
      number_to_currency order.subtotal
    end
    column :grand_total do |order|
      number_to_currency order.grand_total
    end
    column :created_at
    actions
  end

  filter :customer
  filter :status, as: :select, collection: ['pending', 'paid', 'shipped']
  filter :created_at

  show do
    attributes_table do
      row :id
      row :customer
      row :status do |order|
        status_tag order.status
      end
      row :subtotal do |order|
        number_to_currency order.subtotal
      end
      row :gst_amount do |order|
        number_to_currency order.gst_amount
      end
      row :pst_amount do |order|
        number_to_currency order.pst_amount
      end
      row :hst_amount do |order|
        number_to_currency order.hst_amount
      end
      row :grand_total do |order|
        number_to_currency order.grand_total
      end
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :name
        column :quantity
        column :price do |item|
          number_to_currency item.price
        end
        column :subtotal do |item|
          number_to_currency(item.price * item.quantity)
        end
      end
    end

    panel "Customer Details" do
      attributes_table_for order.customer do
        row :email
        row :address
        row :city
        row :province
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :customer, as: :select, collection: Customer.all
      f.input :status, as: :select, collection: ['pending', 'paid', 'shipped']
      f.input :subtotal
      f.input :gst_amount, label: "GST Amount"
      f.input :pst_amount, label: "PST Amount"
      f.input :hst_amount, label: "HST Amount"
      f.input :grand_total
    end
    f.actions
  end

  # Batch action to mark orders as paid
  batch_action :mark_as_paid do |ids|
    batch_action_collection.find(ids).each do |order|
      order.update(status: 'paid')
    end
    redirect_to collection_path, alert: "Orders marked as paid"
  end

  # Batch action to mark orders as shipped
  batch_action :mark_as_shipped do |ids|
    batch_action_collection.find(ids).each do |order|
      order.update(status: 'shipped')
    end
    redirect_to collection_path, alert: "Orders marked as shipped"
  end
end
