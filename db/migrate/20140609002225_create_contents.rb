class CreateContents < ActiveRecord::Migration
  def up
      create_table :contents do |t|
        t.string "list_name",:null => false
        t.integer "numCol", :default => 0, :null => false 
        t.string "fields" 
        t.timestamps
      end
    end
    def down
       drop_table :contents
  end
end
