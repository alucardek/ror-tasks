class TodoList
	class Item 
	
	  def initialize(item_description)
		@item_description = item_description
		@complete=false
	  end
	  
	  def to_s
	  	@item_description.to_s
	  end
	  
	  def completed?
		@complete
	  end
	  
	  def complete
		@complete=true
	  end
	  
	end


  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    if items==nil then raise(IllegalArgument) end
   	@items=[]
	
	items.each do |item| 
	  @items << Item.new(item)
	end
	
  end
  
  def empty?
	@items.empty?
  end
    
  def size
	@items.size
  end
   
  def <<(item_description)
  	@items << Item.new(item_description)
  end
  
  def last
  	@items.last
  end
  
  def first
  	@items.first
  end
  
  def completed?(num)
	@items[num].completed?
  end
  
  def complete(num)
  	@items[num].complete
  end
  
end




