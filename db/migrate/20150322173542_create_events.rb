class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.integer :group_id
      t.timestamp :time
      t.integer :type

      t.timestamps
    end
  end
end
