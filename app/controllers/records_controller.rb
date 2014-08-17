class RecordsController < ApplicationController
    layout false

    #----------------------------------------------------------------------------
    def copy
        params.require(:name)
        Record.set_table(params[:name].to_s)
        Record.reset_column_information
        paramId = params[:id]
        listName = params[:name]
        recordID = params[:recordID]
        puts "recordID = "+recordID.inspect
        rec = Record.find(params[:recordID]).attributes
        puts "rec = "+rec.inspect
        #rec.tap { |hs| hs.delete(:id) }
        puts "rec2 = "+rec.except("id").inspect
        record = Record.new(rec.except("id", "created_at", "updated_at"))
        record.save
        redirect_to(:controller => 'list', :action => 'show', :id => paramId, :name => listName)
    end

    #----------------------------------------------------------------------------
    def show
    end
    
    #----------------------------------------------------------------------------
    def new
        params.require(:name)
        @paramId = params[:id].to_i
        @listName = params[:name]
        Record.set_table(params[:name].to_s)
        Record.reset_column_information
        @colNames = Record.column_names()
        #puts "Here "+@colNames.inspect
        Record.new
        @record = Record
        puts "Here new"+ @paramId.inspect
        @numCols = @colNames.length
    end

    #----------------------------------------------------------------------------
    def create
        #FIXME
        #params.require(:list).permit(names:[], :name, :id)
        params.require(:list).permit!
        paramId = params[:id].to_i
        name = params[:name]
 
        columnIndexs = params[:list][:names].keys
        columnValues = params[:list][:names].values
        numCols = columnIndexs.length
        puts "columnIndexs = #{columnIndexs}" 
        puts "columnValues = #{columnValues}" 
        
        Record.set_table(params[:name].to_s)
        columns = Record.column_names()
        puts "columns = #{columns}"
      
        #build hash
        recHash = Hash.new()
        x=0
        loop do
            recHash[columns[columnIndexs[x].to_i-1]] = columnValues[x]
            puts "Here again"+recHash.inspect
            x+=1
            break if x >= numCols
        end
        record = Record.new(recHash)
        puts "Here final"+recHash.inspect
        
        string = ":#{columns[columnIndexs[0].to_i].inspect} => #{columnValues[0].inspect}"
        record.save
        puts "Here "+string.inspect
        redirect_to(:controller => 'list', :action => 'show', :id => paramId, :name => name)       
    end
 
    #---------------------------------------------------------------------------- 
    def edit
        params.require(:name)
        Record.set_table(params[:name].to_s)
        Record.reset_column_information
        @paramId = params[:id].to_i
        @listName = params[:name]
        @recordID = params[:recordID]
        @record = Record
        @rec = Record.find(params[:recordID])
        @colNames = Record.column_names()
        #puts "Here "+@colNames.inspect
        @values  = @rec.attributes.values
        puts "@values[0] = #{@values[0]}" 
        #puts "Here new"+ @paramId.inspect
        @numCols = @colNames.length
    end

    #----------------------------------------------------------------------------
    def update
        #FIXME
        #params.require(:list).permit(:name, :recordID, :id, :names =>{} )
        params.require(:list).permit!
        #params.require(:namelist).permit!
        
        paramId = params[:id].to_i
        name = params[:name]
        recordID = params[:recordID]  
   
        columnIndexs = params[:list][:names].keys
        columnValues = params[:list][:names].values
        numCols = columnIndexs.length
        puts "columnIndexs = #{columnIndexs}" 
        puts "columnValues = #{columnValues}" 
            
        Record.set_table(params[:name].to_s)
        Record.reset_column_information
        columns = Record.column_names()
        puts "columns = #{columns}"
            
        #build hash
        recHash = Hash.new()
        x=0
        loop do
            recHash[columns[columnIndexs[x].to_i-1]] = columnValues[x]
            puts "Here again"+recHash.inspect
            x+=1
            break if x >= numCols
        end
        record = Record.find(recordID)
        #@values  = record.attributes.values
        #puts "@values[0] = #{@values[0]}" 
        record.update_attributes(recHash)
        #record.attributes = params[:list][:names]
        #record.save false
        puts "Here final"+recHash.inspect
            
        string = ":#{columns[columnIndexs[0].to_i].inspect} => #{columnValues[0].inspect}"
        #record.save
        puts "Here "+string.inspect
        redirect_to(:controller => 'list', :action => 'show', :id => paramId, :name => name)   
    end
  
    #----------------------------------------------------------------------------  
    def delete
        @listID = params[:id]
        @listName = params[:name]
        @recordID = params[:recordID]
    end

    #----------------------------------------------------------------------------  
    def destroy
        listID = params[:id]
        listName = params[:name]
        recordID = params[:recordID]
        Record.set_table(params[:name].to_s)
        Record.reset_column_information
        Record.delete(recordID)
        redirect_to(:controller => 'list', :action => 'show', :id => listID, :name => listName)
    end    
  
    #----------------------------------------------------------------------------   
    def user_params
       #params.require(:list).permit(:name, :recordID, :id, :names {})
       params.require(:list).permit!
       # params.require(:list).permit(:name).tap do |while_listed|
       #while_listed[:names] = params[:list][:names]
       #end
    end
end
