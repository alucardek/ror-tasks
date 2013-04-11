require 'rspec'
require_relative 'spec_helper'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(db: database) }
  let(:database)            { stub }
  let(:item)                { Struct.new(:title,:description).new(title,description) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }

  it "should raise an exception if the database layer is not provided" do
    expect{ TodoList.new(db: nil) }.to raise_error(IllegalArgument)
  end

  context "with empty DB" do

    it "should be empty if there are no items in the DB" do
      stub(database).items_count { 0 }
      list.should be_empty
    end

    it "should return nil for the first and the last item if the DB is empty" do
      stub(database).items_count { 0 }

      list.last.should == nil
      list.first.should == nil
    end

  end

  context "with some items in DB" do

    it "should not be empty if there are some items in the DB" do
      stub(database).items_count { 1 }
      list.should_not be_empty
    end

    it "should return its size" do
      stub(database).items_count { 6 }
      list.size.should == 6
    end

    it "should fetch the first item from the DB" do
      stub(database).items_count {6 }

      mock(database).get_todo_item(0) { item }
      list.first.should == item

      mock(database).get_todo_item(0) { nil }
      list.first.should == nil
    end

    it "should fetch the last item from the DB" do
      stub(database).items_count { 6 }

      mock(database).get_todo_item(5) { item }
      list.last.should == item

      mock(database).get_todo_item(5) { nil }
      list.last.should == nil
    end

    it "should persist the added item" do
      mock(database).add_todo_item(item) { true }
      mock(database).get_todo_item(0).times(2) { item } # dwa razy bo sprawdzam dla first i dla last
      stub(database).items_count { 1 }

      list << item
      list.first.should == item
      list.last.should == item
    end

    it "should not accepting a nil item" do
      stub(database).items_count { 0 }
      dont_allow(database).add_todo_item(nil)

      list << nil
      list.should be_empty
    end

    it "should persist the state of the item" do
      mock(database).todo_item_completed?(0) { false }
      mock(database).complete_todo_item(0,true) { true }
      mock(database).todo_item_completed?(0) { true }
      mock(database).complete_todo_item(0,false) { true }

      mock(database).get_todo_item(0).times(2) { item }

      list.toggle_state(0)
      list.toggle_state(0)
    end

    it "should raise an exception when changing the item state if the item is nil" do
      mock(database).get_todo_item(0) {nil}

      expect{ list.toggle_state(0) }.to raise_error(IllegalArgument)
    end

  end

  context "with empty title of the item" do
    let(:title)   { "" }

    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end

  context "with short title" do
    let(:title)   { "OMG" }

    it "should not accept an item with too short (but not empty) title" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end

  context "with missing description" do
    let(:description) {nil}

    it "should accept of an item with missing description" do
      mock(database).add_todo_item(item) { true }
      mock(database).get_todo_item(0).times(2) { item } # dwa razy bo sprawdzam dla first i dla last
      stub(database).items_count { 1 }

      list << item
      list.first.should == item
      list.last.should == item
    end

  end

  context "with social network" do
    subject(:list)            { TodoList.new(db: database, socl: social_network) }
    #let(:social_network)      { mock!.spam(description) { true }.subject }
    let(:social_network)      { mock } #ALTERNATYWNE PODEJŚCIE - które lepsze?
    let(:social_suffix)        { " - completed!"}

    it "should notify a social network if an item is added to the list" do
      mock(database).add_todo_item( item )  {true}
      mock(social_network).spam(description) {true} # ALTERNATYWNE PODEJŚCIE - które lepsze?

      list << item
    end

    it "should notify a social network if an item is completed" do
      mock(database).add_todo_item( item ) {true}
      mock(social_network).spam(description) {true}  # ALTERNATYWNE PODEJŚCIE - które lepsze?

      mock(database).get_todo_item (0) {item}
      mock(database).todo_item_completed?(0) { false }
      mock(database).complete_todo_item(0, true) {true}
      mock(social_network).spam(description + social_suffix) {true}

      list << item
      list.toggle_state(0)
    end

    context "with empty title of the item" do
      let(:title)   { "" }

      it "should not notify the social network if the title of the item is missing" do
        dont_allow(social_network).spam(description)   # ALTERNATYWNE PODEJŚCIE - które lepsze?
        #dont_allow(database).add_todo_item(item)

        list << item
      end
    end

    context "with missing description" do
      let(:description) {nil}

      it "should notify the social network if the body of the item is missing" do
        mock(database).add_todo_item( item )  {true}
        mock(social_network).spam(description) {true} # ALTERNATYWNE PODEJŚCIE - które lepsze?

        list << item
      end
    end

    context "with notify longer than 255 characters" do
      let(:description)     {"There are several ways to make navigation responsive, and usually the solution we need is quite straightforward. But despite the apparent simplicity, there are many underlying factors which, when thought through and implemented properly, can make a simple solution even better without adding more complexity to the user interface."}
      # > 255 chars
      let(:description_short)   {"There are several ways to make navigation responsive, and usually the solution we need is quite straightforward. But despite the apparent simplicity, there are many underlying factors which, when thought through and implemented properly, can make a s"}
      # == 250 chars
      let(:description_short_completed)   {"There are several ways to make navigation responsive, and usually the solution we need is quite straightforward. But despite the apparent simplicity, there are many underlying factors which, when thought through and implemented properly,"}
      # == 237 chars (for complete action)
      let(:suffix_255)   {"(...)"}

      it "should cut the title of the item when notifying the SN while adding an item" do
        mock(database).add_todo_item( item )  {true}
        #mock(social_network).spam(description_short + suffix_255) {true}
        mock(social_network).spam(description[0...250] + suffix_255) {true}

        list << item
      end

      it "should cut the title of the item when notifying the SN while completing the item" do
        mock(database).add_todo_item( item ) {true}
        mock(social_network).spam(description_short + suffix_255) {true}
        mock(database).get_todo_item (0) {item}
        mock(database).todo_item_completed?(0) { false }
        mock(database).complete_todo_item(0, true) {true}
        mock(social_network).spam(description_short_completed + suffix_255 + social_suffix) {true}


        list << item
        list.toggle_state(0)
      end
    end

  end


end