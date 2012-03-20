require_dependency 'principal'
require_dependency 'user'

class User < Principal
  has_many :already_reads, :order => :created_on
  has_many :already_read_issues, :through => :already_reads, :source => :issue
end
