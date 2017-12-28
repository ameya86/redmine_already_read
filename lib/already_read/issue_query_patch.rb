require_dependency 'query'
require_dependency 'issue_query'

IssueQuery.add_available_column(QueryColumn.new(:already_read))
IssueQuery.add_available_column(QueryColumn.new(:already_read_date))

module AlreadyReadIssueQueryPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods) # obj.method

    base.class_eval do
      alias_method_chain :available_filters, :already_read
    end
  end

  module InstanceMethods # obj.method
    # 既読フィルタを追加
    def available_filters_with_already_read
      return @available_filters if @available_filters
      available_filters_without_already_read

      if !has_filter?('already_read')
        if Redmine::VERSION.to_a[0] > 3 ||  # newer or equal to 3.4.0
           Redmine::VERSION.to_a[0] == 3 && Redmine::VERSION.to_a[1] >= 4
          @available_filters['already_read'] = QueryFilter.new(
            'already_read',
            type: :list,
            order: 20,
            values: @available_filters['author_id'][:values],
            name: l(:field_already_read)
          )
        else
          @available_filters['already_read'] = {:type => :list, :order => 20, :values => @available_filters['author_id'][:values], :name => l(:field_already_read)}
        end
      end

      return @available_filters
    end
  end
end

class IssueQuery < Query
  # 既読／未読検出のSQL
  def sql_for_already_read_field(field, operator, value)
    db_table = AlreadyRead.table_name
    # <<自分>>を変換
    if value.include?('me') && value.delete('me')
      if User.current.logged?
        value.push(User.current.id.to_s)
      elsif value.empty?
        value.push("0")
      end
    end
    op = ('=' == operator)? 'IN' : 'NOT IN'

    sql = "#{Issue.table_name}.id #{op} (SELECT #{db_table}.issue_id FROM #{db_table} WHERE " + sql_for_field(field, '=', value, db_table, 'user_id') + ")"

    return sql
  end
end

IssueQuery.send(:include, AlreadyReadIssueQueryPatch)
