require 'spec_helper'

describe Post do

  it "requires chat input" do
    User.delete_all
    Post.delete_all
    Post.new.should_not be_valid
    Post.new(:message => "Hi!", :user => Factory(:user)).should be_valid
  end

  it "saves location" do
    p = Post.new(:message => "Hi!", :user => Factory(:user), :lat => 41.8781136, :lon => -87.6297982 )
    p.save
    p.location.should == "Chicago, IL"
  end
end