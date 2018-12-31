class AlreadyReadListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = {})
    stylesheet_link_tag 'already_read', :plugin => 'redmine_already_read'
  end
end
