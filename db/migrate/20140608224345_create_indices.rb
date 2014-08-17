class CreateIndices < ActiveRecord::Migration
  def up
    create_table :indices do |t|
      t.string "index_name",:null => false
      t.timestamps
    end
  end
  def down
     drop_table :indices
  end
end
