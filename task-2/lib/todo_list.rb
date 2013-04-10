class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(options={})
    raise(IllegalArgument) unless options[:db]
    @db=options[:db]
    @socl=options[:socl]
  end

  def empty?
    @db.items_count == 0
  end

  def size
    @db.items_count
  end

  def << (item)
    unless item.nil? || item.title.nil? || item.title.empty? || item.title.length < 5
      @db.add_todo_item(item)
      message = (item.description.nil? ? nil : item.description )
      @socl.spam(message) if @socl
    end
  end

  def first
    @db.get_todo_item(0) unless @db.items_count == 0
  end

  def last
    @db.get_todo_item(self.size - 1) unless @db.items_count == 0
  end

  def toggle_state(index)
    item=@db.get_todo_item(index)
    unless item.nil?
      #@db.complete_todo_item(index, !@db.todo_item_completed?(index))  <= szybsze rozwiązanie gdy nie ma socl
      unless @db.todo_item_completed?(index)
        @db.complete_todo_item(index, true)
        message = item.description + " - completed!" unless item.description.nil?
        @socl.spam( message ) if @socl
      else
        @db.complete_todo_item(index, false)
      end
    else
      raise IllegalArgument
    end
  end


end
