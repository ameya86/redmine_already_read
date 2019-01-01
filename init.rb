require 'redmine'
require 'already_read/issue_patch'
require 'already_read/issues_controller_patch'
require 'already_read/user_patch'
require 'already_read/issue_query_patch'
require 'already_read/menu_manager_patch'
require 'already_read/view_hook'

Redmine::Plugin.register :redmine_already_read do
  name 'Redmine Already Read plugin'
  author 'OZAWA Yasuhiro'
  description 'Markup read issues.'
  version '0.0.5'
  url 'https://github.com/ameya86/redmine_already_read'
  author_url 'http://blog.livedoor.jp/ameya86/'

  # "活動"にチケットイベントとして登録
  activity_provider :issues, :class_name => 'AlreadyRead'
end
