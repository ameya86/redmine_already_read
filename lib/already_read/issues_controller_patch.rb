require_dependency 'issues_controller'

class IssuesController < ApplicationController
  # Overide Controller's authorize filter, exclude bulk_set_read
  before_filter :authorize, :except => [:index, :bulk_set_read]
  after_filter :issue_read, :only => [:show]
  after_filter :bulk_set_read, :only => [:bulk_edit, :bulk_update, :destroy]

  def bulk_set_read
	issues = Issue.find(params["issues"]);
	Rails::logger.info "AlreadyRead Plugin: bulk_set_read:  #{params}, issues: #{issues}" if Rails::logger && Rails::logger.info	  	  		  
	if params[:set_unread]
        AlreadyRead.destroy_all(:issue_id => params[:ids], :user_id => User.current.id)
    else
        User.current.already_read_issues << issues.reject{|issue| issue.already_read?}
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
