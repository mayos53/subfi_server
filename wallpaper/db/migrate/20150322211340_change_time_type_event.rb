class ChangeTimeTypeEvent < ActiveRecord::Migration
  def change
  	change_column :events, :time, :integer
  end
end
