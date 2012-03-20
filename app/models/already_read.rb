class AlreadyRead < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue

  validates_presence_of :user, :issue
end
