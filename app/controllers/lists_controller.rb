class ListsController < ApplicationController
  layout false;
  
  def index
      @lists = Contents.order("id ASC")
  end
  
  
end
