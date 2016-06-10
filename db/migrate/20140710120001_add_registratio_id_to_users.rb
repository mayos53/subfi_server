class AddRegistratioIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :registrationId, :string
  end
end
