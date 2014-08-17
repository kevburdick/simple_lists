class Record < ActiveRecord::Base

    def self.set_table (name)
             self.table_name = name
    end
    
end
