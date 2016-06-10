class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :administrator_id
      t.integer :group_id
      t.integer :user_id

      t.timestamps
    end
  end
end
