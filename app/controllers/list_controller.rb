class ListController < ApplicationController
    layout false;
    
    #----------------------------------------------------------------------------
    def renameColumns
        @listName = params[:name]
        @listID = params[:id]
        List.set_table(params[:name].to_s)
        @list = List
        @colNames = List.column_names() 
        @numCols = @colNames.length
        puts "@colNames = #{@colNames}"
    end
    
     #----------------------------------------------------------------------------
     def updateColumns
         #FIXME
	 #params.require(:list).permit(:name, :recordID, :id, :names =>{} )
         params.require(:list).permit!
         List.set_table(params[:name].to_s)
         listName = params[:name].to_s
         listID = params[:id]
         oldNames = params[:list].keys
         newNames = params[:list].values
         for index in 0 ... oldNames.length
             if newNames[index] != oldNames[index] and newNames[index] != ""
                 puts "newNames: #{newNames[index]}"
                 if List.rename_column(listName, oldNames[index], newNames[index])
                     render('renameColumn') 
                 end    
             end 
         end
         redirect_to(:controller => 'list', :action => 'show', :id => listID, :name => listName)
            
    end
    
    #----------------------------------------------------------------------------
    def deleteColumns
        @listName = params[:name]
        @listID = params[:id]
        List.set_table(params[:name].to_s)
        @colNames = List.column_names() 
        @numCols = @colNames.length
        puts "@colNames = #{@colNames}"
    end
  
    #----------------------------------------------------------------------------
    def destroyColumns
        params.require(:list).permit!
        listName = params[:name].to_s
        listID = params[:id]
        puts "@listName = #{listName}"
        hash = params[:list][:names]
        puts "hash.keys = #{hash.keys}"
        col = hash.keys
        puts "hash.values = #{hash.values}"
        
        List.set_table(params[:name].to_s)
        @colNames = List.column_names() 
        
        for index in 0 ... hash.keys.length
       	    if hash[col[index].to_s] == '1'
        	puts "delete column= "+@colNames[col[index].to_i].to_s
      	        if List.remove_column(listName,@colNames[col[index].to_i].to_s)
      	    	    render('deleteColumn')     
      	        end
      	    end	
        end
        redirect_to(:controller => 'list', :action => 'show', :id => listID, :name => listName)
    end    
  
    #----------------------------------------------------------------------------
    def createColumn
        params.require(:list).permit(:colName,:type)
        @listName = params[:name]
        #puts "tblName = #{tblName}"
        colName = params[:list][:colName]
        #puts "colName = #{colName}"
        colType = params[:list][:type]
        @paramID = params[:id]
        #puts "colType = #{colType}"
        List.set_table(params[:name].to_s) 
        if List.add_column(@listName,colName,colType)
            render('addColumn') 
        else
            List.add_column(@listName,'created','datetime')
            List.add_column(@listName,'updated','datetime')
            List.reset_column_information
            List.find_each do |list|
	        list.created = list.created_at
	        list.updated = list.updated_at
	        list.save
	    end
	    List.remove_column(@listName,"created_at")
	    List.remove_column(@listName,"updated_at")
            List.add_column(@listName, "created_at", "datetime")
            List.add_column(@listName, "updated_at", "datetime")
            List.reset_column_information
	    List.find_each do |list|
	        list.created_at = list.created
	        list.updated_at = list.updated 
	        list.save
	    end
            List.remove_column(@listName,"created")
	    List.remove_column(@listName,"updated")
            redirect_to(:controller => 'list', :action => 'show', :id => @paramID, :name => @listName)  
        end
    end
   
   #----------------------------------------------------------------------------
    def addColumn
         @listName = params[:name]
         @paramID = params[:id]      
    end
    
    #----------------------------------------------------------------------------
    def create
        #FIXME
        #params.require(:list).permit(names:[], types:[] :name)
        params.require(:list).permit!
       
        listName = params[:name].to_s
        colNames = params[:list][:names]
        colTypes = params[:list][:types]
        puts "@nameList = #{colNames}"
        #@nameList = List.new()
        #if there is error go back to new or go to index
        if List.create_table(listName)
            render('new') 
        else
            x=1 
            loop do
  	        List.add_column(listName, colNames["#{x.to_s}"].to_s, colTypes["#{x.to_s}"].to_s) 
  	        x+=1
 	        break if x > colNames.length
	    end
            #List.add_column(params[:name].to_s, colNames["2"].to_s)
            #Add timestamps here
            List.add_column(listName, "created_at", "datetime")
            List.add_column(listName, "updated_at", "datetime")
            Contents.create(:list_name => listName) 
            #Contents.save()
	    redirect_to(:controller => 'lists', :action => 'index')
        end
    end
  
    #----------------------------------------------------------------------------
    def configure
        params.require(:list).permit(:numCol, :name)
        @listName = params[:list][:name]
        @numCols = params[:list][:numCol].to_i
    end
   
    #----------------------------------------------------------------------------
    def show
        #@singleList = Contents.find(params[:id])
        @paramID = params[:id].to_i
        @listName = params[:name]
        
        List.set_table(params[:name].to_s)
        #rake sync:copy
        List.reset_column_information
        puts "set table "+params[:name].to_s
        @fullResultList = List.all.order("id ASC")
        puts " @fullResultList #{@fullResultList.inspect}"
        if(@fullResultList == "")
            @numRecords = 0
        else
            @numRecords = @fullResultList.count
        end    
        puts "@numRecords #{@numRecords}"
        @colNames = List.column_names() 
        @numCols = @colNames.length
        puts "show @numCols #{@numCols}"
        @values = []
        if(@fullResultList != "") 
            for index in 0 ... @fullResultList.count
                recHash = @fullResultList[index].attributes
                puts " recHash #{recHash}"
                recKeys = recHash.keys
                puts " recKeys #{recKeys}"
                recValue = []
                recValue = recHash.values
                puts "array length "+recValue.length.to_s
                puts "recValue #{recValue}"
                recArray = recValue.to_s.partition(",")
                puts "recArray #{recArray}"
                @values<< recValue 
            end 
        end
    end

    #----------------------------------------------------------------------------  
    def edit
    end
  
    #----------------------------------------------------------------------------
    def delete
        @listName = params[:name]
        @listID = params[:id]
    end
      
    #----------------------------------------------------------------------------  
    def destroy
        params.require(:name)
        listName = params[:name].to_s
        listID = params[:id]
        puts "@listName = #{listName}"
        if List.drop_table(listName)
            render('delete') 
        else      
            Contents.destroy(listID) 
            redirect_to(:controller => 'lists', :action => 'index')
        end
    end    
end
