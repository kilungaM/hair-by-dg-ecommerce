ActiveAdmin.register Category do
  config.filters = false

  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :products_count do |category|
      category.products.count
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end