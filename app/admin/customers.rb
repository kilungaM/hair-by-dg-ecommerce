ActiveAdmin.register Customer do
  permit_params :email, :address, :city, :province_id

  index do
    selectable_column
    id_column
    column :email
    column :city
    column :province
    column "Total Orders" do |customer|
      customer.orders.count
    end
    column :created_at
    actions
  end

  filter :email
  filter :city
  filter :province
  filter :created_at

  show do
    attributes_table do
      row :id
      row :email
      row :address
      row :city
      row :province
      row :created_at
      row :updated_at
    end

    panel "Orders" do
      table_for customer.orders do
        column :id do |order|
          link_to order.id, admin_order_path(order)
        end
        column :status do |order|
          status_tag order.status
        end
        column :grand_total do |order|
          number_to_currency order.grand_total
        end
        column :created_at
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :address
      f.input :city
      f.input :province, as: :select, collection: Province.all
    end
    f.actions
  end
end
