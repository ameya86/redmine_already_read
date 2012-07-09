require 'redmine'
require 'already_read/already_read_hooks'
require 'already_read/issue_patch'
require 'already_read/issues_controller_patch'
require 'already_read/user_patch'
require 'already_read/query_patch'

Redmine::Plugin.register :redmine_already_read do
  name 'Redmine Already Read plugin'
  author 'OZAWA Yasuhiro'
  description 'Markup read issues.'
  version '0.0.1'
  url 'https://github.com/ameya86/redmine_already_read'
  author_url 'http://blog.livedoor.jp/ameya86/'

  Redmine::AccessControl.permission(:view_issues).actions << "issues/bulk_set_read" unless Redmine::AccessControl.permission(:view_issues).actions.include?("issues/bulk_set_read")

end
