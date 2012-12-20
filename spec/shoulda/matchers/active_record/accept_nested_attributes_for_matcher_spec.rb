require "spec_helper"

describe Shoulda::Matchers::ActiveRecord::AcceptNestedAttributesForMatcher do
  it "accepts an existing declaration" do
    accepting_children.should accept_nested_attributes_for(:children)
  end

  it "rejects a missing declaration" do
    matcher = accepts_nested_attributes_for(:children)

    matcher.matches?(accepting_children).should be_false

    matcher.failure_message.should == "Expected Parent to accept nested attributes for children (is not declared)"
  end

  context "allow_destroy" do
    it "accepts a valid truthy value" do
      matching = accepting_children(:allow_destroy => true)

      accept_nested_attributes_for.allow_destroy(true).matches?(matching).should be_true
    end

    it "accepts a valid falsey value" do
      matching = accepting_children(:allow_destroy => false)

      matching.should accept_nested_attributes_for(:children).allow_destroy(false)
    end

    it "rejects an invalid truthy value" do
      fail "FIXME, start here"
      Parent.accepts_nested_attributes_for :children, :allow_destroy => true
      matcher.allow_destroy(false).matches?(parent).should be_false
      matcher.failure_message.should =~ /should not allow destroy/
    end

    it "rejects an invalid falsey value" do
      Parent.accepts_nested_attributes_for :children, :allow_destroy => false
      matcher.allow_destroy(true).matches?(parent).should be_false
      matcher.failure_message.should =~ /should allow destroy/
    end
  end

  context "limit" do
    it "accepts a correct value" do
      Parent.accepts_nested_attributes_for :children, :limit => 3
      matcher.limit(3).matches?(parent).should be_true
    end

    it "rejects a false value" do
      Parent.accepts_nested_attributes_for :children, :limit => 3
      matcher.limit(2).matches?(parent).should be_false
      matcher.failure_message.should =~ /limit should be 2, got 3/
    end
  end

  context "update_only" do
    it "accepts a valid truthy value" do
      Parent.accepts_nested_attributes_for :children, :update_only => true
      matcher.update_only(true).matches?(parent).should be_true
    end

    it "accepts a valid falsey value" do
      Parent.accepts_nested_attributes_for :children, :update_only => false
      matcher.update_only(false).matches?(parent).should be_true
    end

    it "rejects an invalid truthy value" do
      Parent.accepts_nested_attributes_for :children, :update_only => true
      matcher.update_only(false).matches?(parent).should be_false
      matcher.failure_message.should =~ /should not be update only/
    end

    it "rejects an invalid falsey value" do
      Parent.accepts_nested_attributes_for :children, :update_only => false
      matcher.update_only(true).matches?(parent).should be_false
      matcher.failure_message.should =~ /should be update only/
    end
  end

  def accepting_children(options)
    define_model :child, :parent_id => :integer
    define_model :parent do
      has_many :children
      accepts_nested_attributes_for :children, options
    end
  end

  def rejecting
    define_model :child, :parent_id => :integer
    define_model :parent do
      has_many :children
    end
  end
end
