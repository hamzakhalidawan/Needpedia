class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.text :summary
      t.text :description
      t.json :haves
      t.json :wants
      t.integer :user_id

      t.timestamps
    end
  end
end
