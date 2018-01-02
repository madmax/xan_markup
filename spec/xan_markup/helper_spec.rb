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
      expect(helper).to receive(:markup_test)
      helper.markupize("this is markup {{test}} tag")
    end

    it "should not raise exception if tag is not defined" do
      expect { helper.markupize("this is {{undefined}} tag")}.to_not raise_error(NoMethodError)
    end

    it "should return text that tag is not defined" do
      expect(helper.markupize("this is markup {{ test }} tag")).to include("missing tag: test")
    end

    it "should replace tag with content returned by markup markupizer" do
      allow(helper).to receive_messages(markup_best_language: "Ruby")
      expect(helper.markupize("Best language is: {{ best_language }}")).to include("Ruby")
    end
  end


  describe Markupizer do

    it "should replace content with data returned from block" do
      markupizer = Markupizer.new("this is markup {{test}} tag")
      expect(markupizer.markupize {|tag| "SUPER" }).to include("SUPER")
    end

    it "should allow block tag" do
      markupizer = Markupizer.new("this is markup {{test}}tag{{/test}}")
      expect(markupizer.markupize {|tag| tag.content.upcase }).to include("TAG")
    end

    it "should allow nestd block tags" do
      markupizer = Markupizer.new("{{test}}tag {{test2}}test2{{/test2}}{{/test}}")
      expect(markupizer.markupize {|tag| tag.content.upcase }).to eq("TAG TEST2")
    end

    it "should allow multiple identical tags in the same content" do
      markupizer = Markupizer.new("{{test}}A{{/test}} {{test}}B{{/test}}")
      expect(markupizer.markupize {|tag| tag.content }).to eq("A B")
    end

    it "should return two block tags" do
      markupizer = Markupizer.new('this is {{a}}A{{/a}} markup {{b}}B{{/b}}')
      expect(markupizer.tags.size).to eq(2)
    end

    it "should allow multiline blocks" do
      markupizer = Markupizer.new("{{test}}\nA{{/test}}")
      expect(markupizer.markupize {|tag| tag.content }).to eq("\nA")
    end

    it "should return two tags (whitespaces allowed)" do
      markupizer = Markupizer.new('this is {{awesome}} markup {{test}}')
      expect(markupizer.tags.size).to eq(2)
    end

    it "should return tag even when whitespace inside tag is used" do
      markupizer = Markupizer.new('this is markup {{ test }} tag')
      expect(markupizer.tags.size).to eq(1)
    end

    it "should give tag object with proper name" do
      markupizer = Markupizer.new('this is markup {{test name="xan"}} tag')
      expect(markupizer.tags.first.name).to eq("test")
    end

    it "should give tag object with proper args" do
      markupizer = Markupizer.new('this is markup {{test name="xan"}}')
      expect(markupizer.tags.first.args).to eq(name: "xan")
    end

    it "should give tag args when using single quotes" do
      markupizer = Markupizer.new("this is markup {{test name='xan'}} tag")
      expect(markupizer.tags.first.args).to eq(name: "xan")
    end

    it "should give tag args when quotes are skipped" do
      markupizer = Markupizer.new("this is markup {{test name=xan}} tag")
      expect(markupizer.tags.first.args).to eq(name: "xan")
    end

    it "should works with classes that inherance from string" do
      markupizer = Markupizer.new SafeBuffer.new("{{test}}")
      expect(markupizer.tags.size).to eq(1)
    end

    it "should allow change syntax" do
      markupizer = Markupizer.new "[test]", /\[ ?(.*?) ?\]/
      expect(markupizer.tags.size).to eq(1)
    end
  end
end
