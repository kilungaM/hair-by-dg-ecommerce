ActiveAdmin.register PageContent do
  permit_params :title, :content, :slug

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug, hint: "Use 'about' or 'contact'"
      f.input :content, as: :text, input_html: { rows: 10 }
    end
    f.actions
  end
end