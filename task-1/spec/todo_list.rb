require 'bundler/setup'
require 'rspec/expectations'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(items) }
  let(:items)               { [] }
  let(:item_description)    { "Buy toilet paper" }
  let(:second_description)  { "Make ruby homework" }
  let(:third_description)	  { "Optimaze it" }


  context "with no items" do
    it { should be_empty }

    it "should raise an exception when nil is passed to the constructor" do
      expect { TodoList.new(nil) }.to raise_error(IllegalArgument)
    end

    it "should have size of 0" do
      list.size.should == 0
    end

    it "should accept an item" do
      list << item_description
      list.should_not be_empty
    end

    it "should add the item to the end" do
      list << item_description
      list.last.to_s.should == item_description
    end


    it "should have the added item uncompleted" do
      list << item_description
      list.completed?(0).should be_false
    end
  end
  
  context "with one item" do
    let(:items)             { [item_description] }

    it { should_not be_empty }

    it "should have size of 1" do
      list.size.should == 1
    end

    it "should have the first and the last item the same" do
      list.first.to_s.should == list.last.to_s
    end

    it "should not have the first item completed" do
      list.completed?(0).should be_false
    end

    it "should change the state of a completed item" do
      list.complete(0)
      list.completed?(0).should be_true
    end
  end
  
  context "with many items" do
  	let(:items)            { [item_description, second_description, third_description] }

    it "should return completed items" do
      list.complete(2)
      list.complete(1)
      completed=list.show_completed
      completed.size.should == 2
      completed.first.to_s.should == second_description
    end

    it "should return uncompleted items" do
      list.complete(0)
      list.complete(2)
      uncompleted = list.show_uncompleted
      uncompleted.first.to_s.should == second_description
      uncompleted.size.should ==1
    end

    it "should remove an invidual item" do
      list.remove(1)
      list.remove(1)
      list.last.to_s.should == item_description
      list.last.should == list.first
      list.size.should ==1
    end

    it "should remove all completed items" do
      list.complete(0)
      list.complete(2)
      list.remove("completed")
      completed=list.show_completed
      completed.should be_empty
    end
	
  end
  
end
