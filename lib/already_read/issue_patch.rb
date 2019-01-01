require_dependency 'issue'

module AlreadyReadIssuePatch
    # チケットのclassに既読／未読も追加する
    def css_classes
      s = super
      s << ((self.already_read?)? ' read' : ' unread')
      return s
    end
end
Issue.prepend AlreadyReadIssuePatch

class Issue < ActiveRecord::Base
  has_many :already_reads, lambda {includes(:user); order(:created_on)}
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
    AlreadyRead.where(:issue_id => self.id).destroy_all
  end
end
