require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class XanMarkup::HelperTest
  include XanMarkup::Helper
end

describe XanMarkup::Helper do
  let(:helper) { XanMarkup::HelperTest.new }
  
  it "It should call property method when found tag" do
    helper.should_receive(:markup_test)
    helper.markupize("this is markup {{test}} tag")
  end
  
  it "It should property parse one parameter" do
    helper.should_receive(:markup_test).with(:name => "xan")
    helper.markupize('this is markup {{test name="xan"}} tag')
  end
  
  it "It should property parse two parameters" do
    helper.should_receive(:markup_test).with(:name => "xan", :next => "b")
    helper.markupize('this is markup {{test name="xan" next="b"}} tag')
  end
  
  it "It should allow use single quotes too" do
    helper.should_receive(:markup_test).with(:name => "xan")
    helper.markupize("this is markup {{test name='xan'}} tag")
  end
  
  it "It should allow skip quotes too" do
    helper.should_receive(:markup_test).with(:name => "xan")
    helper.markupize("this is markup {{test name=xan}} tag")
  end
  
  it "It should parse two tags property" do
    helper.should_receive(:markup_test).twice
    helper.markupize("this is markup {{test}} {{test}} tag")
  end
  
  it "It should allow white space at beggining and end tag" do
    helper.should_receive(:markup_test)
    helper.markupize("this is markup {{ test }} tag")
  end
  
  it "should not raise exception if tag is not defined" do
    expect { helper.markupize("this is markup {{ test }} tag") }.should_not raise_error(NoMethodError)
  end
  
  it "should replace tag with content returned by markup helper" do
    helper.stub(:markup_best_language).and_return("Ruby")
    helper.markupize("Best language is: {{ best_language }}").should include("Ruby")
  end
  

  
  
  
end
