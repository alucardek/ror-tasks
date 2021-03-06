require 'rspec'
require 'bundler/setup'
require 'rspec/expectations'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe "TodoList" do
  subject(:list)            { TodoList.new(items) }
  let(:items)               { [] }
  let(:item_description)    { "Buy toilet paper" }
  let(:second_description)  { "Make ruby homework" }
  let(:third_description)	  { "Aww..Optimaze it" }


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
      list.last.display_description.should == item_description
    end


    it "should have the added item uncompleted" do
      list << item_description
      list.at(0).completed?.should be_false
    end
  end

  context "with one item" do
    let(:items)             { [item_description] }

    it { should_not be_empty }

    it "should have size of 1" do
      list.size.should == 1
    end

    it "should select one item at particular position" do
      list.at(0).display_description.should == item_description
    end

    it "should have the first and the last item the same" do
      list.first.display_description.should == list.last.display_description
    end

    it "should not have the first item completed" do
      list.at(0).completed?.should be_false
    end

    it "should change the state of a completed item" do
      list.at(0).complete
      list.at(0).completed?.should be_true
    end
  end

  context "with many items" do
    let(:items)            { [item_description, second_description, third_description] }

    it "should return completed items" do
      list.at(2).complete
      list.at(1).complete
      completed=list.show_completed
      completed.size.should == 2
      completed.first.display_description.should == second_description
    end

    it "should return uncompleted items" do
      list.at(0).complete
      list.at(2).complete
      uncompleted = list.show_uncompleted
      uncompleted.first.display_description.should == second_description
      uncompleted.size.should ==1
    end

    it "should remove an invidual item" do
      list.remove(1)
      list.remove(1)
      list.last.display_description.should == item_description
      list.last.should == list.first
      list.size.should ==1
    end

    it "should remove all completed items" do
      list.at(0).complete
      list.at(0).complete
      list.remove("completed")
      completed=list.show_completed
      completed.should be_empty
    end

    it "should revert order of two items" do
      list.reverse(0,1)
      list.first.display_description.should == second_description
    end

    it "should revert the order of all items" do
      list.reverse
      list.first.display_description.should == third_description
      list.last.display_description.should == item_description
    end

    it "should toggle the state of an item" do
      list.at(1).complete
      list.show_completed.first.display_description.should == second_description
      list.at(0).toggle_completness
      list.at(1).toggle_completness
      list.show_completed.first.display_description.should == item_description
    end

    it "should set the state of the item to uncompleted" do
      list.at(1).complete
      list.at(1).uncomplete
      list.show_completed.should be_empty
    end

    it "should change the description of an item" do
      list.at(2).description="aleluja"
      list.last.display_description.should == "aleluja"
    end

    it "should sort the items by name" do
      list.sort_by!("names")
      list.at(2).display_description.should == second_description
    end

    it "should convert the list to text with the following format" do
      list.at(1).complete
      list.completeness_reformating

      list.completeness_reformating.at(1).should == "[x] " + second_description
      list.completeness_reformating.at(0).should == "[ ] " + item_description
    end
  end

end
