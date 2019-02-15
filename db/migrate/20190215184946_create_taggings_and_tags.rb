class CreateTaggingsAndTags < ActiveRecord::Migration[5.1]
  def change
  	create_table :tags do |t|
      t.string :name

      t.timestamps
    end
    create_table :taggings do |t|
      t.belongs_to :post, foreign_key: true
      t.belongs_to :tag, foreign_key: true

      t.timestamps
    end
  end
end
