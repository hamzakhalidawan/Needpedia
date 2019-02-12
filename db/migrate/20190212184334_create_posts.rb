class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :creator_id
      t.string :post_type
      t.boolean :approved

      t.timestamps
    end
  end
end
