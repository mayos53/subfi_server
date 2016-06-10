class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.string :user_name
      t.integer :group_id
      t.string :group_name
      t.integer :recommender_id
      t.string :recommender_name

      t.timestamps
    end
  end
end
