class CreateAlreadyReads < ActiveRecord::Migration
  def self.up
    create_table :already_reads do |t|
      t.column :issue_id,   :integer
      t.column :user_id,    :integer
      t.column :created_on, :datetime
    end
    add_index :already_reads, [:issue_id, :user_id], :name => :index_already_reads, :unique => true
  end

  def self.down
    drop_table :already_reads
  end
end
