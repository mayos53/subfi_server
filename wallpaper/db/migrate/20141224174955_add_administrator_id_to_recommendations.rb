class AddAdministratorIdToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :administrator_id, :integer
  end
end
