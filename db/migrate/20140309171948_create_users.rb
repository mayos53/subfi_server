class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.text :countryCode
      t.text :phone
      t.text :code

      t.timestamps
    end
  end
end
