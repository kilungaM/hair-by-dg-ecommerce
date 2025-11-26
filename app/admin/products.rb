ActiveAdmin.register Product do
  config.filters = false

  permit_params :name, :description, :price, :stock, :on_sale, :category_id, :image

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :price
    column :stock
    column :on_sale
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock
      f.input :on_sale
      f.input :category
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock
      row :on_sale
      row :category
      row :image do |product|
        image_tag url_for(product.image) if product.image.attached?
      end
      row :created_at
      row :updated_at
    end
  end
end