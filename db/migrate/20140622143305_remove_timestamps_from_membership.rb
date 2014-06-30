class RemoveTimestampsFromMembership < ActiveRecord::Migration
  def change
    remove_column :memberships, :created_at, :string
    remove_column :memberships, :updated_at, :string
  end
end
