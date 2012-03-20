require_dependency 'issues_controller'

class IssuesController < ApplicationController
  after_filter :issue_read, :only => [:show]

  private
  # 既読フラグを付ける
  def issue_read
    if User.current.logged? && @issue && !@issue.already_read?
      User.current.already_read_issues << @issue
    end
  end
end
