$LOAD_PATH.unshift( File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')) )
require 'gem_console'

describe GemConsole do
  
  before(:each) do
    (!!defined?(IRB)).should be_true
  end
  
  describe "start(project_name)" do
    before(:each) do
      
    end
    
    it "should description" do
      
    end
  end
  
end
