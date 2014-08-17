require 'test_helper'

class AddTableTest < ActionDispatch::IntegrationTest
    
    #holds the text to verify the screen is current screen as expected 
    @@screenCheck = {'lists_index'=>'Table of Contents','list_new'=>'Create List',
                     'list_configure'=>'List:','list_show'=>'List:','record_new'=>'Add Record:','record_edit'=>'Update Record:',
                     'list_delete'=>'Delete List','record_delete'=>'Delete Record:','list_addColumn'=>'Add Column',
                     'list_renameColumn'=>'List:','list_deleteColumn'=>'List:'}
    
    #holds the link text to transfer to corresponding screen
    @@lnkToScreen = {'lists_index_TOC'=>'Table of Contents','list_new'=>'Add New List','record_new'=>'Add Record',
                     'lists_index_delete'=>'Delete','list_show'=>'Delete','list_addColumn'=>'Add',
                     'list_renameColumn'=>'Rename','list_deleteColumn'=>'Remove'}
    
    #holds the button text to transfer to corresponding screen
    @@btnToScreen = {'lists_index'=>'Create', 'list_configure'=>'Create', 'list_show'=>'Create',
                     'list_show_edit'=>'Update','list_show_addColumn'=>'Add',
                     'list_show_renameCol'=>'Rename Columns','list_deleteColumn'=>'Remove Columns'}
    
    @@db_name = 'Test2'
    
    #----------------------------------------------------------------------------  
    def self.onScreen(session, name)
        if session.has_content?(@@screenCheck[name])
            #puts "#{name.to_s} test pass"
        else
            puts "#{name.to_s} broken"
            exit(-1)
        end
    end  
    
    #----------------------------------------------------------------------------  
    def self.textOnScreen(session, text)
        if session.has_content?(text)
            #puts "#{text.to_s} test pass"
        else
            puts "#{text.to_s} broken"
            exit(-1)
        end
    end  
    
    #----------------------------------------------------------------------------  
    def self.linkToScreen(session, name)
        session.click_link(@@lnkToScreen[name])
    end
    
    #----------------------------------------------------------------------------  
        def self.buttonToScreen(session, name)
            session.click_button(@@btnToScreen[name])
    end
    
    #----------------------------------------------------------------------------  
    def self.addNewList(session)
        puts "Test Add New List Start"
        #verify index page
        onScreen(session, 'lists_index')
        linkToScreen(session, 'list_new')
        
        #verify Add List
        puts "...test Add List"
        onScreen(session, 'list_new')
        session.fill_in 'list[name]', :with => @@db_name.to_s
        session.fill_in 'list[numCol]', :with => '1'
        buttonToScreen(session,'list_configure')
        
        #verify Configure New List
        puts "...test Configure New List"
        onScreen(session, 'list_configure')
        session.fill_in 'list[names[1]]', :with => 'column1'
        buttonToScreen(session,'lists_index')    
       
        #verify index page
        puts "...test Table of Contents"
        onScreen(session, 'lists_index')
        
    end
    
    #---------------------------------------------------------------------------- 
    def self.addNewRecord(session)
        puts "Test Add New Record Start"
        #verify index page
        onScreen(session, 'lists_index')
        session.find('tr', text: @@db_name.to_s).click_link('Show')
        
        #verify list/show
        puts "...test Show List"
        onScreen(session, 'list_show')
        linkToScreen(session, 'record_new')
        
        #verify record/new
        puts "...test Add Record Table"
        onScreen(session, 'record_new')
        session.fill_in 'list[names[2]]', :with => 'field2'
        buttonToScreen(session,'list_show')
        
        #verify list/show
        puts "...test Show List"
        onScreen(session, 'list_show')
        linkToScreen(session, 'lists_index_TOC')
        
        #verify index page
        puts "...test Table of Contents"
        onScreen(session, 'lists_index')
       
    end
    #---------------------------------------------------------------------------- 
    def self.deleteList(session)
        puts "Test Delete List Start"
        #verify index page
        onScreen(session, 'lists_index')
        session.find('tr', text: @@db_name.to_s).click_link('Delete')
        
        #verify list/delete
        puts "...test Delete List"
        onScreen(session, 'list_delete')
        linkToScreen(session, 'lists_index_delete')
        
        #verify index page
        puts "...test Table of Contents"
        onScreen(session, 'lists_index')
      
    end
    
    #---------------------------------------------------------------------------- 
    def self.editRecord(session)
        puts "Test Edit Record Start"
        #verify index page
        onScreen(session, 'lists_index')
        session.find('tr', text: @@db_name.to_s).click_link('Show')
            
        #verify list/show
        puts "...test Show List"
        onScreen(session, 'list_show')
        session.find('tr', text: 'field2').click_link('Edit')
            
        #verify record/edit
        puts "...test Edit Record screen"
        onScreen(session, 'record_edit')
        session.fill_in 'list[names[2]]', :with => 'field3'
        buttonToScreen(session,'list_show_edit')
            
        #verify list/show
        puts "...test Show List and verify edit"
        onScreen(session, 'list_show')
        textOnScreen(session, 'field3')
        linkToScreen(session, 'lists_index_TOC')
            
        #verify index page
        puts "...test Table of Contents"
        onScreen(session, 'lists_index')
    end
        
    #---------------------------------------------------------------------------- 
    def self.copyRecord(session)
        puts "Test Copy Record Start"
        #verify index page
        onScreen(session, 'lists_index')
        session.find('tr', text: @@db_name.to_s).click_link('Show')
            
        #verify list/show
        puts "...test Show List"
        onScreen(session, 'list_show')
        session.find('tr', text: 'field3').click_link('Copy')
        
        #verify list/show
	puts "...test Copy Record"
	onScreen(session, 'list_show')
        session.first('tr', text: 'field3').click_link('Edit')
            
        #verify record/edit
        puts "...test Edit Record screen"
        onScreen(session, 'record_edit')
        session.fill_in 'list[names[2]]', :with => 'field2'
        buttonToScreen(session,'list_show_edit')
            
        #verify list/show
        puts "...test Show List and verify copy"
        onScreen(session, 'list_show')
        textOnScreen(session, 'field3')
        linkToScreen(session, 'lists_index_TOC')
            
        #verify index page
        puts "...test Table of Contents"
        onScreen(session, 'lists_index')
    end
    
    #---------------------------------------------------------------------------- 
    def self.deleteRecord(session)
        puts "Test Delete Record Start"
        #verify index page
        onScreen(session, 'lists_index')
        session.find('tr', text: @@db_name.to_s).click_link('Show')
                
        #verify list/show
        puts "...test Show List"
        onScreen(session, 'list_show')
        session.find('tr', text: 'field2').click_link('Delete')
                
        #verify record/edit
        puts "...test Delete Record screen"
        
        onScreen(session, 'record_delete')
        linkToScreen(session, 'list_show')
                
        #verify list/show
        puts "...test Show List and verify delete"
        onScreen(session, 'list_show')
        if session.has_content?('field2')
            puts "...error, verify delete record fails"
	    exit(-1)
	end
        linkToScreen(session, 'lists_index_TOC')
                
        #verify index page
        puts "...test Table of Contents"
        onScreen(session, 'lists_index')
    end
    
    #---------------------------------------------------------------------------- 
    def self.addListColumn(session)
        puts "Test Add Column to List Start"
        #verify index page
        onScreen(session, 'lists_index')
        session.find('tr', text: @@db_name.to_s).click_link('Show')
              
        #verify list/show
        puts "...test Show List"
        onScreen(session, 'list_show')
        linkToScreen(session, 'list_addColumn')
            
        #verify list/show
    	puts "...test Copy Record"
    	onScreen(session, 'list_addColumn')
        session.fill_in 'list[colName]', :with => 'field4'
        buttonToScreen(session,'list_show_addColumn')
              
        #verify list/show
        puts "...test Show List and verify add column"
        onScreen(session, 'list_show')
        textOnScreen(session, 'field4')
        linkToScreen(session, 'lists_index_TOC')
             
        #verify index page
        puts "...test Table of Contents"
        onScreen(session, 'lists_index')
    end
    
    #---------------------------------------------------------------------------- 
    def self.renameListColumn(session)
        puts "Test Rename Column to List Start"
        #verify index page
        onScreen(session, 'lists_index')
        session.find('tr', text: @@db_name.to_s).click_link('Show')
               
        #verify list/show
        puts "...test Show List"
        onScreen(session, 'list_show')
        linkToScreen(session, 'list_renameColumn')
               
        #verify list/rename
        puts "...test Rename Column"
        onScreen(session, 'list_renameColumn')
        session.fill_in 'list[field4]', :with => 'field5'
        buttonToScreen(session,'list_show_renameCol')
               
        #verify list/show
        puts "...test Show List and verify add column"
        onScreen(session, 'list_show')
        textOnScreen(session, 'field5')
        linkToScreen(session, 'lists_index_TOC')
               
        #verify index page
        puts "...test Table of Contents"
        onScreen(session, 'lists_index')
    end
    #---------------------------------------------------------------------------- 
    def self.deleteListColumn(session)
        puts "Test Delete List Column Start"
        #verify index page
        onScreen(session, 'lists_index')
        session.find('tr', text: @@db_name.to_s).click_link('Show')
                     
        #verify list/show
        puts "...test Show List"
        onScreen(session, 'list_show')
        linkToScreen(session, 'list_deleteColumn')
                 
        #verify list/delete
        puts "...test Delete Column"
        onScreen(session, 'list_deleteColumn')
        session.check('list[names[2]]')
        buttonToScreen(session,'list_deleteColumn')
                      
        #verify list/show
        puts "...test Show List and verify delete column"
        onScreen(session, 'list_show')
        if session.has_content?('field5')
            puts "...error, verify delete column fails"
            exit(-1)
   	end
        linkToScreen(session, 'lists_index_TOC')
                 
        #verify index page
        puts "...test Table of Contents"
        onScreen(session, 'lists_index')
    end
    
    #----------------------------------------------------------------------------    
    puts "\n\nBlackbox Test\n"
   
    #setup driver  
    session = Capybara::Session.new(:selenium)
    #FIXME Enter location where server is
    session.visit "http://example:3000"
    
    addNewList(session)
    addNewRecord(session)
    editRecord(session)
    copyRecord(session)
    deleteRecord(session)
    addListColumn(session)       
    renameListColumn(session) 
    deleteListColumn(session)
    deleteList(session)
   
end
