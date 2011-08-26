require 'spec_helper'

describe LayoutHelper do

  describe "#title" do
    it "should set show_title var as passed" do
      helper.title("Testing Title").should == true
    end

    it "should set show_title true by default" do
      helper.title("Testing Title")
      helper.show_title?.should be true
    end

    it "should set show title as passed id passed" do
      helper.title("Testing Title", false)
      helper.show_title?.should be false
      helper.title("Testing Title", true)
      helper.show_title?.should be true
    end

  end

  describe "#stylesheet" do
    it "should receive styles" do
      styles = "application"
      helper.should_receive(:content_for).with(:head)
      helper.stylesheet(styles)
    end
  end

  describe "#javascript" do
    it "should receive javascript" do
      js = "application"
      helper.should_receive(:content_for).with(:head)
      helper.javascript(js)
    end

  end

end