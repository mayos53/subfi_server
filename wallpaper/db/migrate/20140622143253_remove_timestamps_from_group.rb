class RemoveTimestampsFromGroup < ActiveRecord::Migration
  def change
    remove_column :groups, :created_at, :string
    remove_column :groups, :updated_at, :string
  end
end
