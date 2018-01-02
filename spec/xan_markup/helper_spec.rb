require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SafeBuffer < String
  def gsub(*args, &block)
    super
  end
  def to_s
    self
  end

end

module XanMarkup

  class TestHelper
    include Helper
  end


  describe Helper do
    let(:helper) { TestHelper.new }

    it "should call property method when found tag" do
      helper.should_receive(:markup_test)
      helper.markupize("this is markup {{test}} tag")
    end

    it "should not raise exception if tag is not defined" do
      expect { helper.markupize("this is {{undefined}} tag")}.to_not raise_error(NoMethodError)
    end

    it "should return text that tag is not defined" do
      helper.markupize("this is markup {{ test }} tag").should include("missing tag: test")
    end

    it "should replace tag with content returned by markup markupizer" do
      helper.stub(:markup_best_language).and_return("Ruby")
      helper.markupize("Best language is: {{ best_language }}").should include("Ruby")
    end
  end


  describe Markupizer do

    it "should replace content with data returned from block" do
      markupizer = Markupizer.new("this is markup {{test}} tag")
      markupizer.markupize {|tag| "SUPER" }.should include("SUPER")
    end

    it "should allow block tag" do
      markupizer = Markupizer.new("this is markup {{test}}tag{{/test}}")
      markupizer.markupize {|tag| tag.content.upcase }.should include("TAG")
    end

    it "should allow nestd block tags" do
      markupizer = Markupizer.new("{{test}}tag {{test2}}test2{{/test2}}{{/test}}")
      markupizer.markupize {|tag| tag.content.upcase }.should == "TAG TEST2"
    end

    it "should allow multiple identical tags in the same content" do
      markupizer = Markupizer.new("{{test}}A{{/test}} {{test}}B{{/test}}")
      markupizer.markupize {|tag| tag.content }.should == "A B"
    end

    it "should return two block tags" do
      markupizer = Markupizer.new('this is {{a}}A{{/a}} markup {{b}}B{{/b}}')
      markupizer.should have(2).tags
    end



    it "should return two tags (whitespaces allowed)" do
      markupizer = Markupizer.new('this is {{awesome}} markup {{test}}')
      markupizer.should have(2).tags
    end

    it "should return tag even when whitespace inside tag is used" do
      markupizer = Markupizer.new('this is markup {{ test }} tag')
      markupizer.should have(1).tags
    end

    it "should give tag object with proper name" do
      markupizer = Markupizer.new('this is markup {{test name="xan"}} tag')
      markupizer.tags.first.name.should == "test"
    end

    it "should give tag object with proper args" do
      markupizer = Markupizer.new('this is markup {{test name="xan"}}')
      markupizer.tags.first.args.should == {name: "xan"}
    end

    it "should give tag args when using single quotes" do
      markupizer = Markupizer.new("this is markup {{test name='xan'}} tag")
      markupizer.tags.first.args.should == {name: "xan"}
    end

    it "should give tag args when quotes are skipped" do
      markupizer = Markupizer.new("this is markup {{test name=xan}} tag")
      markupizer.tags.first.args.should == {name: "xan"}
    end

    it "should works with classes that inherance from string" do
      markupizer = Markupizer.new SafeBuffer.new("{{test}}")
      markupizer.should have(1).tags
    end

    it "should allow change syntax" do
      markupizer = Markupizer.new "[test]", /\[ ?(.*?) ?\]/
      markupizer.should have(1).tags
    end

  end
end
