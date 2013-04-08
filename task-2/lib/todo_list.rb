class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(options={})
    raise(IllegalArgument) unless options[:db]
    @db=options[:db]
  end

  def empty?
    @db.items_count == 0
  end

  def size
    @db.items_count
  end

  def << (item)
    @db.add_todo_item(item) unless item.title.empty? || item.title.nil? || item.nil?
  end

  def first
    @db.get_todo_item(0) unless @db.items_count == 0
  end

  def last
    @db.get_todo_item(self.size - 1) unless @db.items_count == 0
  end

  def toggle_state(index)
    if @db.get_todo_item(index)
      @db.complete_todo_item(index, !@db.todo_item_completed?(index))
    else
      raise IllegalArgument
    end
  end

end
