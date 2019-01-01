require_dependency 'redmine/menu_manager'

module AlreadyReadMenuManagerPatch
    def render_menu(menu, project=nil)
      html = super(menu, project)
      if menu == :top_menu && html =~ /^(.*<a.*?class="my-page".*?)(<\/a.*)$/
        html1 = $1
        html2 = $2

        query = IssueQuery.new(:name => l(:label_assigned_to_me_issues), :user => User.current)
        query.add_filter 'assigned_to_id', '=', ['me']
        assigned_to_me_count = query.issue_count

        query.add_filter 'already_read', '!=', ['me']
        unread_count = query.issue_count

        counter_str = %Q{ <span class="ar_counter unread" title="　　#{l(:label_already_read_unread)}">#{unread_count}</span>}
        counter_str << %Q{/<span class="ar_counter assigned_to_me" title="　　#{l(:label_assigned_to_me_issues)}">#{assigned_to_me_count}</span>}
        html = html1 + counter_str + html2
      end
      return html.html_safe
    end
end

Redmine::MenuManager::MenuHelper.prepend AlreadyReadMenuManagerPatch
include Redmine::MenuManager::MenuHelper
