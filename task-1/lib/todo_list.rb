require 'delegate'

# DECORATOR FOR ITEM
class CompletenessReformatter < SimpleDelegator
  # decorate the item
  def completeness_reformat
    state = self.completed? ? "x" : " "
    "[#{state}] #{self.display_description}"
  end
end


# ITEM
class Item

  # Initialize the ITEM with +description and completeness status+ (uncompleted by default).
  def initialize(item_description)
    @item_description = item_description
    @complete=false
  end

  #show Item description only
  def display_description
    @item_description.to_s
  end

  # changing Item's description
  def description=(description)
    @item_description=description
  end

  # checking if Item is completed
  def completed?
    @complete
  end

  # change Item to completed
  def complete
    @complete=true
  end

  # change Item to uncompleted
  def uncomplete
    @complete=false
  end

  # change Item' completness state to oposite
  def toggle_completness
    @complete= @complete ? false : true
  end

  # decorating Item with [x] or [ ]
  def completeness_reformating
    decorated_item = CompletenessReformatter.new(self)
    decorated_item.completeness_reformat
  end

end


#TODOLIST
class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
    raise(IllegalArgument) if items.nil?
   	@items=[]
    items.each do |item|
      @items << Item.new(item)
    end
  end

  # Checking if TodoList is empty
  def empty?
	  @items.empty?
  end

  # Checking number of TodoList's elements/tasks
  def size
	  @items.size
  end

  # Adding new item to TodoList
  def <<(item_description)
  	@items << Item.new(item_description)
  end

  # Pointing up item on particular position
  def at(index)
    @items.at(index)
  end

  # Pointing up first item
  def first
  	@items.first
  end

  # Pointing up last item
  def last
    @items.last
  end

  # Show all completed items
  def show_completed
    completed=[]

    @items.each do |item|
	    completed << item if item.completed?
    end

  	completed
  end

  # Show all uncompleted items
  def show_uncompleted
    uncompleted=[]
    @items.each do |item|
	    uncompleted << item unless item.completed?
	  end
	  uncompleted
  end

  # Remove item at particular position
  def remove(param)
  	if param=="completed"
      @items.delete_if {|item| item.completed?} 
    elsif param=="uncompleted" 
      @items.delete_if {|item| (item.completed? == false)}
    else 
      @items.delete_at(param)
    end
  end

  # Reverse position of two items
  def reverse(first=nil,second=nil)
    if first && second
      @items[first..second]=@items[first..second].reverse
    else
      @items.reverse!
    end
  end

  # Sort TodoList (by names by default)
  def sort_by!(param)
    if param=="names"
      @items.sort_by! {|items| items.display_description}
    end
  end

  # Decorate TodoList with [x] or [ ], depended on completness
  def completeness_reformating
    items_reformated=[]

    @items.each do |item|
      items_reformated << item.completeness_reformating
    end

    items_reformated
  end

end