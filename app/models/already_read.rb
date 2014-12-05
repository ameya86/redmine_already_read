class AlreadyRead < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue

  validates_presence_of :user, :issue

  # "活動"に表示されるようにイベントをプロバイダを登録する
  acts_as_event :title => Proc.new {|o| "#{o.issue.tracker.name} ##{o.issue.id} (#{o.issue.status}): #{o.issue.subject}"},
                :type => 'issue-note', #Proc.new {|o| 'issue' + (o.closed? ? ' closed' : '') },
				:datetime => :created_on,
                :author => :user,
                :url => Proc.new {|o| {:controller => 'issues', :action => 'show', :id => o.issue.id}}

  acts_as_activity_provider :timestamp => 'created_on',
							:find_options => {:include => [ {:issue => [:project, :tracker, :status]}, :user ]},
                            :author_key => :user_id, :type => 'issues'


  scope :visible, lambda {|*args|
    includes(:issue => :project).
    references(:project).
    where(Issue.visible_condition(args.shift || User.current, *args))
  }
						  
						  
  # 状態の説明
  #  "活動"で参照する
  def description
    return l(:activity_already_read)
  end

  # 属するプロジェクト
  # "活動"で参照する
  def project
    return self.issue.project
  end
end
