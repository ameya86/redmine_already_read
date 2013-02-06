require_dependency 'issue'

module AlreadyReadIssuePatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods) # obj.method

    base.class_eval do
      alias_method_chain :css_classes, :already_read
    end
  end

  module InstanceMethods # obj.method
    # チケットのclassに既読／未読も追加する
    def css_classes_with_already_read
      s = css_classes_without_already_read
      s << ((self.already_read?)? ' read' : ' unread')
      return s
    end
  end
end

class Issue < ActiveRecord::Base
  has_many :already_reads, :include => [:user], :order => :created_on
  has_many :already_read_users, :through => :already_reads, :source => :user
  after_update :reset_already_read

  # 状態を文字で返す
  def already_read(user = User.current)
    return (already_read?(user))? l(:label_already_read_read) : l(:label_already_read_unread)
  end

  # 既読ならtrueを返す
  def already_read?(user = User.current)
   return !user.anonymous? && user.already_read_issue_ids.include?(self.id)
  end

  # チケットを読んだ日
  def already_read_date(user = User.current)
    read = already_reads.detect{|r| r.user_id == user.id}
    return (read)? read.created_on : nil
  end

  private
  # 既読フラグはチケットを更新したらリセットする
  def reset_already_read
    AlreadyRead.destroy_all(:issue_id => self.id)
  end
end

Issue.send(:include, AlreadyReadIssuePatch)
