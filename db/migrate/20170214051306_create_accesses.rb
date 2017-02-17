class CreateAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :accesses do |t|
      t.integer :article_id
      t.integer :count ,default: 0

      t.timestamps
    end
  end
end
