require_dependency 'issues_controller'

class IssuesController < ApplicationController
  after_filter :issue_read, :only => [:show]
  prepend_before_filter :find_issues, :only => [:bulk_set_read, :bulk_edit, :bulk_update, :destroy]

  def bulk_set_read
    if params[:set_read]
      User.current.already_read_issues << @issues.reject{|issue| issue.already_read?}
    elsif params[:set_unread]
        AlreadyRead.destroy_all(:issue_id => params[:ids], :user_id => User.current.id)
    end
    redirect_back_or_default({:controller => 'issues', :action => 'index', :project_id => @project})
  end

  private
  # 既読フラグを付ける
  def issue_read
    if User.current.logged? && @issue && !@issue.already_read?
      User.current.already_read_issues << @issue
    end
  end
end
