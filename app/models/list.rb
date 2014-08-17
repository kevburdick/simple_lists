class List < ActiveRecord::Base

    #----------------------------------------------------------------------------
    #Creates a new table based on the name passed in 
    def self.create_table (name)
      puts "create  table: "+name 
      begin
        ActiveRecord::Schema.define do
          create_table "#{name.to_s}" do |t|
          #t.timestamps
          end
        end
        rescue Exception => err
        return err.message
      end
    end 
    
    #----------------------------------------------------------------------------
    #Adds a column to a table based on the name and type passed in 
    def self.add_column (name, colName, colType)
          puts "add column: "+name +" "+colName+" "+colType
          begin
            ActiveRecord::Schema.define do
              add_column :"#{name.to_s}", :"#{colName.to_s}", :"#{colType.to_s}"
            end
            rescue Exception => err
            return err.message
          end
    end
    
    #----------------------------------------------------------------------------
    #Removes a column from a table based on the name and type passed in 
    def self.remove_column (name, colName)
        puts "remove column: "+name +" "+colName
        begin
            ActiveRecord::Schema.define do
                remove_column :"#{name.to_s}", :"#{colName.to_s}"
            end
            rescue Exception => err
            return err.message
        end
    end
    
    #----------------------------------------------------------------------------
    #Removes a column from a table based on the name and type passed in 
    def self.rename_column (name, colName, colType)
        puts "rename column: "+name +" "+colName+" "+colType
        begin
            ActiveRecord::Schema.define do
                rename_column :"#{name.to_s}", :"#{colName.to_s}", :"#{colType.to_s}"
            end
            rescue Exception => err
            return err.message
        end
    end
    
    #----------------------------------------------------------------------------
    #Sets the table name based on the name passed in 
    def self.set_table (name)
        self.table_name = name
    end
    
    #----------------------------------------------------------------------------
    #Drops the table based on the name passed in 
    def self.drop_table (name)
        puts "delete table: "+name
        begin
            ActiveRecord::Schema.define do
                drop_table :"#{name}"       
            end
            rescue Exception => err
            return err.message
        end
    end
    
    #----------------------------------------------------------------------------
    
end
