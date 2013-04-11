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

    def uncomplete
      @complete=false
    end

    def toggle
      @complete= @complete ? false : true
    end

    def description=(description)
      @item_description=description
    end


	  
	end

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    raise(IllegalArgument) if items.nil?
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

  def at(index)
    @items.at(index)
  end

  def first
  	@items.first
  end

  def last
    @items.last
  end

  def show_completed
    completed=[]
    @items.each do |item|
	  completed << item if item.completed?
	end
	completed
  end
  
  def show_uncompleted
    uncompleted=[]
    @items.each do |item|
	  uncompleted << item unless item.completed?
	end
	uncompleted
  end

  def remove(param)
  	if param=="completed"
      @items.delete_if {|item| item.completed?} 
    elsif param=="uncompleted" 
      @items.delete_if {|item| (item.completed? == false)}
    else 
      @items.delete_at(param)
    end
  end

  def reverse(first=nil,second=nil)
    if first && second
      @items[first..second]=@items[first..second].reverse
    else
      @items.reverse!
    end
  end

  def sort_by!(param)
    if param=="names"
      @items.sort_by! {|items| items.to_s}
    end
  end

  def convertx
    @items.map {|item| item.completed? ? "[x] "+ item.to_s : "[ ] "+item.to_s }
  end

  def completed?(index)
    @items[index].completed?
  end

  def complete(index)
    @items[index].complete
  end

  def uncomplete(index)
    @items[index].uncomplete
  end

  def toggle(index)
    @items[index].toggle
  end

end