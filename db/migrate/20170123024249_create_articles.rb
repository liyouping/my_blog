class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :category_id
      t.text :content
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
