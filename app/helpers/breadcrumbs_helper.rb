module BreadcrumbsHelper
  def breadcrumb(name, url = nil)
    @breadcrumbs ||= []
    @breadcrumbs << { name: name, url: url }
  end

  def render_breadcrumbs
    return '' if @breadcrumbs.blank? || @breadcrumbs.length < 2

    content_tag :nav, aria: { label: 'breadcrumb' } do
      content_tag :ol, class: 'breadcrumb' do
        @breadcrumbs.map.with_index do |crumb, index|
          li_class = 'breadcrumb-item'
          li_class += ' active' if index == @breadcrumbs.length - 1

          content_tag :li, class: li_class do
            if index == @breadcrumbs.length - 1 || crumb[:url].nil?
              crumb[:name]
            else
              link_to crumb[:name], crumb[:url]
            end
          end
        end.join.html_safe
      end
    end
  end
end
